//
//  TabBarView.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 15/02/2025.
//

import SwiftUI

struct MuqlaTabBar: View {
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    @State var localSelection: TabBarItem

    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Image("ic-tabbar-background")
                    .resizable()
                    .frame(height: 80)
            }
            writePageButton
            
            // Tab Items
            HStack {
                homeButton
                Spacer()
                settingsButton
            }
            .frame(height: 80)
            .padding(.horizontal, 70)
            .offset(y: 35)
        }
        .onChange(of: selection) {
            localSelection = selection
        }
    }
    
    var homeButton: some View {
        let tab = TabBarItem.home
        return Button {
            switchToTap(tab: .home)
        } label: {
            VStack {
                Image(systemName: "house")
                    .font(.system(size: 22))
                    .foregroundColor(selection == tab ? Color.purple : Color.gray)
                
                Text("Home")
                    .font(.caption)
                    .foregroundColor(selection == tab ? Color.purple : Color.gray)
            }
        }
    }
    var settingsButton: some View {
        let tab = TabBarItem.settings
        return Button {
            switchToTap(tab: .settings)
        } label: {
            VStack {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 22))
                    .foregroundColor(localSelection == tab ? Color.purple : Color.gray)
                
                Text("Settings")
                    .font(.caption)
                    .foregroundColor(localSelection == tab ? Color.purple : Color.gray)
            }
        }
    }
    var writePageButton: some View {
        Button(action: {
            switchToTap(tab: .writePage)
        }) {
            Image(systemName: "note.text")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundColor(.white)
                .padding(18)
                .background(
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .shadow(color: Color.purple.opacity(0.6), radius: 10, x: 0, y: 6)
                )
        }
        .offset(y: -1)
    }
}

extension MuqlaTabBar {
    private func switchToTap(tab: TabBarItem) {
        selection = tab
    }
}


#Preview {
    let tabs = TabBarItem.allCases
    
    VStack {
        Spacer()
        MuqlaTabBar(tabs: tabs, selection: .constant(tabs.first!), localSelection: tabs.first!)
            .frame(maxHeight: 150)
    }
    .background(.blue)
}
