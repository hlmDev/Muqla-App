//
//  MainView.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 16/02/2025.
//

import SwiftUI

struct MainView: View {
    @State private var tabSelection: TabBarItem = .home
    
    var body: some View {
        tabBar
    }
    
    var tabBar: some View {
        ZStack {
            MuqlaTabBarController(selection: $tabSelection) {
                homeTab
                writePageTab
                settingsTab
            }
        }
    }
    
    var homeTab: some View {
        HomeView()
            .tabBarItem(tab: .home, selection: $tabSelection)
    }
    var settingsTab: some View {
        NovelListView()
            .tabBarItem(tab: .settings, selection: $tabSelection)
    }
    var writePageTab: some View {
        WriteBookView()
            .tabBarItem(tab: .writePage, selection: $tabSelection)
    }
}

#Preview {
    MainView()
}
