//
//  PreferenceKeys+Extension.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 16/02/2025.
//

import SwiftUI


struct TQTabBarItemsPreferenceKeys: PreferenceKey {
    static var defaultValue: [TabBarItem] = []
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}

struct TQTabBarItemsViewModifier: ViewModifier {
    let tab: TabBarItem
    @Binding var selection: TabBarItem
    func body(content: Content) -> some View {
            content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TQTabBarItemsPreferenceKeys.self, value: [tab])
    }
}

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View  {
        modifier(TQTabBarItemsViewModifier(tab: tab, selection: selection))
    }
}
