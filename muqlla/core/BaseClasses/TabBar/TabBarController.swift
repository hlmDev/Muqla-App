//
//  TabBarController.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 16/02/2025.
//

import SwiftUI

struct MuqlaTabBarController<Content: View>: View {
    
    @Binding var selection : TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    @State var showTabBar: Bool = true
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
            if showTabBar {
                VStack(spacing: 0) {
                    Spacer()
                    MuqlaTabBar(tabs: tabs, selection: $selection, localSelection: selection)
                        .background(.clear)
                        .frame(maxHeight: 150)
                }
            }
        }
        .ignoresSafeArea(.all)
        .onPreferenceChange(TQTabBarItemsPreferenceKeys.self, perform: { value in
            self.tabs = value
        })
        .onReceive(Global.shared.$showTabBar) { show in
            self.showTabBar = show
        }
        .background(.clear)
    }
}


#Preview {
    MuqlaTabBarController(selection: .constant(.home)) {
        Color.red
    }
}
