//
//  MQButton.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 14/02/2025.
//

import SwiftUI

enum MQGlowingButtonType {
    case loginButton
    case appleLoginButton
    case googleLoginButton
}


struct MQGlowingButton: View {
    let type: MQGlowingButtonType
    let icon: Image?
    let text: String
    let baseColor: Color
    let width: CGFloat
    let height: CGFloat
    var buttonTapped: (() -> ()) = {}
    
    var body: some View {
        Button(action: {
            buttonTapped()
        }) {
            HStack(spacing: 8) {
                rawIcon
                MQText(text, .defaultFont(size: 16))
            }
            .frame(maxWidth: width, idealHeight: height)
            .foregroundStyle(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(baseColor)
                    .overlay(
                        buttonGradiant
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    )
            )
        }
    }
    
    var rawIcon: some View {
        if let icon {
            switch type {
            case .loginButton:
                return AnyView(icon)
                
            case .appleLoginButton:
                return AnyView(
                    icon
                        .frame(height: 16)
                        .aspectRatio(1.186291739894552, contentMode: .fit)
                )
                
            case .googleLoginButton:
                return AnyView(
                    icon
                        .resizable()
                        .frame(width: 16, height: 16, alignment: .center)
                )
            }
        }
        return AnyView(EmptyView())
    }
    
    var cornerRadius: CGFloat {
        switch type {
        case .loginButton:
            10
        case .appleLoginButton, .googleLoginButton:
            16
        }
    }
    
    var buttonGradiant: some View {
        switch type {
        case .loginButton:
            AnyView(LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.1),
                    Color.black.opacity(0.5)
                ]),
                startPoint: .top,
                endPoint: .bottom
            ))
        case .appleLoginButton, .googleLoginButton:
            AnyView(RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.1),
                    Color.clear,
                    Color.black.opacity(0.8)
                ]),
                center: .bottom,
                startRadius: -80,
                endRadius: 100
            ))
        }
    }
}


// Factory
extension MQGlowingButton {
    init() {
        type = .loginButton
        icon = Image("ic-google")
        text = "HELLO"
        width = 100
        height = 20
        baseColor = .cPrimary
    }
    
    init(type: MQGlowingButtonType = .loginButton, icon: Image? = nil, text: String, baseColor: Color, width: CGFloat? = nil, height: CGFloat? = nil, buttonTapped: @escaping (() -> ()) = {}) {
        self.type = type
        self.icon = icon
        self.text = text
        self.baseColor = baseColor
        self.width = width ?? .infinity
        self.height = height ?? 30
        self.buttonTapped = buttonTapped
    }
    
    static func defaultLoginButton(buttonTapped: @escaping (() -> ())) -> MQGlowingButton {
        return .init(type: .loginButton, text: "Login", baseColor: ColorsManager.normal.loginButtonPlainColor.toColor, height: 16, buttonTapped: buttonTapped)
    }
    static func appleLoginButton(buttonTapped: @escaping (() -> ())) -> MQGlowingButton {
        return .init(type: .appleLoginButton, icon: AssetsManager.normal.appleIcon, text: "Apple", baseColor: ColorsManager.normal.appleButtonPlainColor.toColor, width: 150, height: 20, buttonTapped: buttonTapped)
    }
    static func googleLoginButton(buttonTapped: @escaping (() -> ())) -> MQGlowingButton {
        return .init(type: .googleLoginButton, icon: AssetsManager.normal.googleIcon, text: "Google", baseColor: ColorsManager.normal.googleButtonPlainColor.toColor, width: 150, height: 20, buttonTapped: buttonTapped)
    }
}



#Preview {
    MQGlowingButton()
}
