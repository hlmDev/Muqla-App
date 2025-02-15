//
//  MQText.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 14/02/2025.
//

import SwiftUI

struct MQText: View {
    
    private let text: String
    private let font: MQFont?
    private var color: Color?
    
    init(_ text: String, _ font: MQFont = .defaultFont, color: Color? = .cPrimaryText) {
        self.text = text
        self.font = font
        self.color = color
    }
    
    var body: some View {
        var text = Text(text)
        switch font {
        case .defaultFont(let size, let weight):
            text = text
                .font(.system(size: size, weight: weight))
        case .custom(let font):
            text = text
                .font(font)
        default:
            break
        }
        
        let view = text
            .if(color != nil) { view in
                view.foregroundStyle(color!)
            }
        return view
    }
    
    
    func applyLinearGradient(_ colors: [Color], start: UnitPoint = .top, end: UnitPoint = .bottom) -> some View {
        var newText = self
        newText.color = nil
        
        let view = newText.foregroundStyle(
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: start,
                endPoint: end
            )
        )
        return view
    }
}
