//
//  AppDelegate.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 10/03/2025.
//

import Foundation
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        handleAuthentication()
        return true
    }
    
    func handleAuthentication() {
        Task {
            let supabaseManager = SupabaseManager.shared
            do {
                let session = try await supabaseManager.getCurrentSession()
                let isExpired = session.isExpired
                Global.shared.isAuthenticated = !isExpired
            } catch {
                Global.shared.isAuthenticated = false
            }
        }
    }
}
