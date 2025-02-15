//
//  OverrideSystemFont.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 14/02/2025.
//

import SwiftUICore
import UIKit

public enum MQFont {
    case defaultFont(size: CGFloat = 14, Font.Weight = .regular)
    case custom(font: Font)
}

extension MQFont {
    static var defaultFont: MQFont { return Self.defaultFont() }
}

extension Font {
    
    /// Create a font with the large title text style.
    public static var largeTitle: Font {
        return Font.custom("IBMPlexSansArabic-Regular", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
    }
    
    /// Create a font with the title text style.
    public static var title: Font {
        return Font.custom("IBMPlexSansArabic-Regular", size: UIFont.preferredFont(forTextStyle: .title1).pointSize)
    }
    
    /// Create a font with the headline text style.
    public static var headline: Font {
        return Font.custom("IBMPlexSansArabic-Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize)
    }
    
    /// Create a font with the subheadline text style.
    public static var subheadline: Font {
        return Font.custom("IBMPlexSansArabic-Light", size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
    }
    
    /// Create a font with the body text style.
    public static var body: Font {
        return Font.custom("IBMPlexSansArabic-Regular", size: UIFont.preferredFont(forTextStyle: .body).pointSize)
    }
    
    /// Create a font with the callout text style.
    public static var callout: Font {
        return Font.custom("IBMPlexSansArabic-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize)
    }
    
    /// Create a font with the footnote text style.
    public static var footnote: Font {
        return Font.custom("IBMPlexSansArabic-Regular", size: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
    }
    
    /// Create a font with the caption text style.
    public static var caption: Font {
        return Font.custom("IBMPlexSansArabic-Regular", size: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
    }

    public static func system(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        var font = "IBMPlexSansArabic-Regular"
        switch weight {
        case .bold: font = "IBMPlexSansArabic-Bold"
        case .heavy: font = "IBMPlexSansArabic-Bold"
        case .light: font = "IBMPlexSansArabic-Light"
        case .medium: font = "IBMPlexSansArabic-Medium"
        case .semibold: font = "IBMPlexSansArabic-SemiBold"
        case .thin: font = "IBMPlexSansArabic-Thin"
        case .ultraLight: font = "IBMPlexSansArabic-ExtraLight"
        default: break
        }
        return Font.custom(font, size: size)
    }
}
