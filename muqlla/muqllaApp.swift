//
//  muqllaApp.swift
//  muqlla
//
//  Created by Ahlam Majed on 17/12/2024.
//

/*import SwiftUI

@main
struct muqllaApp: App {
    var body: some Scene {
        WindowGroup {
            KitSplash()
                .preferredColorScheme(.dark)
        }
    }
}*/
import SwiftUI

@main
struct MuqllaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var global = Global.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let isAuthenticated = global.isAuthenticated {
                    if isAuthenticated {
                        MainView()
                            .preferredColorScheme(.dark)
                        
                    } else {
                        AuthView()
                            .preferredColorScheme(.dark)
                    }
                }
            }
        }
    }
}

