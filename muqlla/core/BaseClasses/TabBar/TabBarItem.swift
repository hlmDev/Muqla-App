//
//  TabBarItem.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 16/02/2025.
//

import SwiftUI

enum TabBarItem: Hashable, Identifiable, CaseIterable {
    case home, settings, writePage
    
    public func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
    
    static func == (lhs: TabBarItem, rhs: TabBarItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int {
        switch self {
        case .home:
            return 1
        case .settings:
            return 2
        case .writePage:
            return 3
        }
    }
    var icon: Image {
        switch self {
        case .home:
            return Image("icExplore_unselected")
        case .settings:
            return Image("icTayaqan_gray")
        case .writePage:
            return Image("icQRCode_unselected")
        }
    }
    var iconSelected: Image? {
        switch self {
        case .home:
            return Image("icExplore_selected")
        case .settings:
            return Image("icTayaqan_selected")
        case .writePage:
            return Image("icQRCode_selected")
        }
    }
    var iconSize: CGFloat {
        switch self {
        case .home:
            return 35
        case .settings:
            return 35
        case .writePage:
            return 35
        }
    }
    var iconSizeSelected: CGFloat {
        switch self {
        case .home:
            return 45
        case .settings:
            return 45
        case .writePage:
            return 45
        }
    }
    var title: String {
        switch self {
        case .home:
            return "tab_explore"
        case .settings:
            return "tab_tayaqan"
        case .writePage:
            return "tab_qr_code"
        }
    }
    var iconColor: Color {
        switch self {
        case .home:
            return Color.cPrimary
        case .settings:
            return Color.cPrimary
        case .writePage:
            return Color.cPrimary
        }
    }
    var textColorUnselected: Color {
        switch self {
        case .home:
            return Color.gray
        case .settings:
            return Color.gray
        case .writePage:
            return Color.gray
        }
    }
}
