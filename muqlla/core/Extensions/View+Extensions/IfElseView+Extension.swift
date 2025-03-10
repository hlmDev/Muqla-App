//
//  IfElseView+Extension.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 14/02/2025.
//

import Foundation
import SwiftUICore

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content, elseTransform: ((Self) -> Content)? = nil) -> some View {
        if condition {
            transform(self)
        } else {
            if let elseTransform {
                elseTransform(self)
            } else {
                self
            }
        }
    }
}
