//
//  MQTextField.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 15/02/2025.
//

import SwiftUI


enum MQTextFieldType {
    case normal
    case password
}


struct MQTextField: View {
    let type: MQTextFieldType
    let placeholder: String
    let fontSize: CGFloat
    let backgroundColor: Color
    let textColor: Color
    let borderColor: Color
    
    @Binding var field: String    
    @Binding var isHighlighted: Bool
    
    init(field: Binding<String>, isHighlighted: Binding<Bool>? = nil, type: MQTextFieldType = .normal, placeholder: String, fontSize: CGFloat = 14, backgroundColor: Color = .cSecondary, textColor: Color = .cMuted, borderColor: Color = .cBorder) {
        self._field = field
        self._isHighlighted = isHighlighted ?? .constant(false)
        self.type = type
        self.placeholder = placeholder
        self.fontSize = fontSize
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.borderColor = borderColor
    }
    
    var body: some View {
        rawField
        .padding()
        .font(.system(size: fontSize, weight: .regular))
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
                .stroke(borderColor, lineWidth: 2)
        )
        .foregroundColor(textColor)
    }
    
    var rawField: some View {
        switch type {
        case .normal:
            AnyView(textfield)
        case .password:
            AnyView(secureField)
        }
    }
    var textfield: some View {
        TextField(field, text: $field,
                  prompt: Text(placeholder).foregroundColor(textColor)
        )
    }
    var secureField: some View {
        SecureField(field, text: $field,
                    prompt: Text(placeholder).foregroundColor(textColor)
        )
    }
}

