//
//  Supabase.swift.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 10/03/2025.
//

import Foundation
import Supabase

class SupabaseManager {
    
    static let shared = SupabaseManager()
    
    private let supabase = SupabaseClient(
        supabaseURL: URL(string: EnvironmentManager.shared.SUPABASE_URL!)!,
        supabaseKey: EnvironmentManager.shared.SUPABASE_KEY!
    )
    
    func getCurrentSession() async throws -> Session {
        let session = try await supabase.auth.session
        print(session)
        return session
    }
    
    func signOut() {
        Task {
            try await supabase.auth.signOut()
        }
    }
    
    func signInWithApple(idToken: String, nonce: String) async throws {
        let credentials = OpenIDConnectCredentials(provider: .apple, idToken: idToken, nonce: nonce)
        let session = try? await supabase.auth.signInWithIdToken(credentials: credentials)
    }
}
