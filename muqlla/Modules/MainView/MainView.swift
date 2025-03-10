//
//  MainView.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 16/02/2025.
//

import SwiftUI

struct MainView: View {
    @State private var tabSelection: TabBarItem = .settings
    
    var body: some View {
        tabBar
    }
    
    var tabBar: some View {
        ZStack {
            MuqlaTabBarController(selection: $tabSelection) {
                homeTab
                settingsTab
            }
        }
    }
    
    var homeTab: some View {
        HomePageView()
            .tabBarItem(tab: .home, selection: $tabSelection)
    }
    var settingsTab: some View {
        NovelListView()
            .tabBarItem(tab: .settings, selection: $tabSelection)
    }
}

#Preview {
    MainView()
}
