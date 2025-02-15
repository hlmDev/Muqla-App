//
//  ColorsManager.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 14/02/2025.
//

import UIKit
import SwiftUI

class ColorsManager {
    static let normal = ColorsManager()
    
    let loginButtonPlainColor = UIColor.cPrimary
    let appleButtonPlainColor = UIColor(hex: "433956")
    let googleButtonPlainColor = UIColor(hex: "56393E")
}

public extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let aColor, rValue, gValue, bValue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (aColor, rValue, gValue, bValue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (aColor, rValue, gValue, bValue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (aColor, rValue, gValue, bValue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (aColor, rValue, gValue, bValue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(rValue) / 255, green: CGFloat(gValue) / 255, blue: CGFloat(bValue) / 255, alpha: CGFloat(aColor) / 255)
    }
    
    var toColor: Color {
        Color(uiColor: self)
    }
}
