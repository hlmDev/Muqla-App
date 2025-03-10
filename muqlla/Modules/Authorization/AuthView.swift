//
//  AuthView.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 14/02/2025.
//

import SwiftUI
import Combine

struct AuthView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        ZStack {
            backgroundEffect
            content
                .padding(.bottom, 100)
                .wrapInsideAutoFocusScrollView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.cBackground)
        .ignoresSafeArea(.all, edges: .top)
        .wrapInsideBaseView()
    }
    
    var backgroundEffect: some View {
        VStack {
            AssetsManager.normal.authBackgroundEffect
            Spacer()
        }
    }
    
    var content: some View {
        LazyVStack(spacing: 30) {
            appIcon
                .padding(.top, 120)
                .padding(.bottom, 10)
            titles
            signView
            dataForm
            forgotPasswordView
            btnLogin
            Spacer()
        }
        .padding()
    }
    var appIcon: some View {
        AssetsManager.normal.muqlaAppIcon
            .resizable()
            .frame(width: 100, height: 100, alignment: .center)
    }
    var titles: some View {
        VStack {
            MQText("Step into a world of Endless Stories",
                   color: .cMuted)
            MQText("Muqla | مقلة",
                   .defaultFont(size: 32, .bold))
            .applyLinearGradient([.cMuted, .white])
        }
    }
    var signView: some View {
        VStack {
            MQText("Sign In", color: .cMuted)
            HStack {
                appleButton
                googleButton
            }
        }
    }
    var appleButton: some View {
        VStack{}
//        SignInWithAppleButton { request in
//            request.requestedScopes = [.fullName, .email]
//        } onCompletion: { result in
//            switch result {
//            case .success(let authorization):
////                if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
////                    vm.saveUserToCloudKit(credential: appleIDCredential)
////                }
//                break
//            case .failure(let error):
////                vm.error = "Sign in failed: \(error.localizedDescription)"
//                break
//            }
//        }
//        .signInWithAppleButtonStyle(.white)
//        .frame(maxWidth: 150, idealHeight: 20)
//        .accessibilityLabel("Sign in with Apple")
//        .accessibilityHint("Double tap to sign in using your Apple ID. This will request access to your name and email")
//        .accessibilityAddTraits(.isButton)
    }
    var googleButton: some View {
        MQGlowingButton.googleLoginButton {
            print("2")
        }
    }
    
    var dataForm: some View {
        VStack {
            emailField
            passwordField
            Spacer()
        }
    }
    var emailField: some View {
        VStack(alignment: .leading, spacing: 16) {
            MQText("Email")
            MQTextField(field: $email, placeholder: "Enter your email")
                .autoFocusable(id: MuqlaConstants.TextFieldIds.AuthView.emailField)
        }
    }
    var passwordField: some View {
        VStack(alignment: .leading, spacing: 16) {
            MQText("Password")
            MQTextField(field: $password, type: .password, placeholder: "Enter your password")
                .autoFocusable(id: MuqlaConstants.TextFieldIds.AuthView.passwordField)
        }
    }
    
    var forgotPasswordView: some View {
        HStack {
            MQText("Forgot your password? ")
            MQText("Click Here")
                .onTapGesture {
                    print("HERE")
                }
        }
    }
    
    var btnLogin: some View {
        MQGlowingButton.defaultLoginButton {
            let language = NSLocale.preferredLanguages[0]
            print(language)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    AuthView()
}
