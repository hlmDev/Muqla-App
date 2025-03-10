//
//  AppleAuthManager.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 10/03/2025.
//

import Foundation
import CryptoKit
import AuthenticationServices

struct SignInAppleResult {
    let idToken: String
    let nonce: String
}

class AppleAuthManager: NSObject {
    private var currentNonce: String?
    private var completionHandler: ((Result<SignInAppleResult, Error>) -> Void)?
    
    func authenticateWithApple(completion: @escaping ((Result<SignInAppleResult, Error>) -> Void)) {
        
        guard UIApplication.getTopViewController() != nil else {
            return
        }
        
        let nonce = randomNonceString()
        currentNonce = nonce
        completionHandler = completion
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce, SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}

extension AppleAuthManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor(frame: .zero)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredentials = authorization.credential as? ASAuthorizationAppleIDCredential, let completionHandler {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent")
            }
            guard let appleIDToken = appleIDCredentials.identityToken else {
                print("Unable to fetch identity token")
                completionHandler(.failure(NSError()))
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                completionHandler(.failure(NSError()))
                return
            }
            
            let result = SignInAppleResult(idToken: idTokenString, nonce: nonce)
            completionHandler(.success(result))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print("Sign In with Apple error: \(error)")
        completionHandler?(.failure(error))
    }
}
