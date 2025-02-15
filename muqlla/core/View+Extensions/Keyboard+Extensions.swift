//
//  Keyboard+Extensions.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 15/02/2025.
//

import SwiftUICore
import UIKit

extension View {
    nonisolated public func removeKeyboardOnTap() -> some View {
        self
            .onTapGesture {
                DispatchQueue.main.async {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
    }
}
