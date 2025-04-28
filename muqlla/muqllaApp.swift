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
    @StateObject private var vm = CloudKitUserViewModel()
    
    var body: some Scene {
        WindowGroup {
            if vm.isNewUser {
                KitSplash()
                    .environmentObject(vm)
                    .preferredColorScheme(.dark)
                

            } else {
                HomePageView()
                    .preferredColorScheme(.dark)

            }
        }
    }
}

