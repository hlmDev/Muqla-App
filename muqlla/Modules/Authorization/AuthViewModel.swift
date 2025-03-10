//
//  AuthViewModel.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 10/03/2025.
//

import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    
    let appleAuthManager = AppleAuthManager()
    
    func authenticateWithApple() {
        loading = true
        appleAuthManager.authenticateWithApple { result in
            switch result {
            case .success(let data):
                self.signInWithApple(data.idToken, data.nonce)
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                self.loading = false
            }
        }
    }
    func signInWithApple(_ idToken: String, _ nonce: String) {
        Task {
            try await SupabaseManager.shared.signInWithApple(idToken: idToken, nonce: nonce)
            Global.shared.isAuthenticated = true
            self.loading = false
        }
    }
}
