//
//  AutoFocusScrollView.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 15/02/2025.
//

import SwiftUI


public struct AutoFocusScrollView<Content: View>: View {
    let content: Content
    
    @State private var keyboardHeight: CGFloat = 0
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        scrollContainer
            
    }
    var scrollContainer: some View {
        ScrollViewReader { proxy in
            ScrollView {
                content
                    .padding(.bottom, keyboardHeight)
            }
            .onAppear {
                setupKeyboardNotifications()
            }
            .onPreferenceChange(FocusableFieldPreferenceKey.self) { fields in
                if let focusedField = fields.first(where: { $0.value as? Bool == true })?.key {
                    withAnimation {
                        proxy.scrollTo(focusedField, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            keyboardHeight = 0
        }
    }
}
