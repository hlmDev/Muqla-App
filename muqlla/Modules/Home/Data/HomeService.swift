//
//  HomeServiceManager.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 11/03/2025.
//

import Foundation

class HomeServiceManager {
    
    
    func fetchCategories() async -> Result<[BookCategory], Error> {
        do {            
            let categories: [BookCategory] = try await SupabaseManager.shared.supabase
                .from("categories")
                .select()
                .execute()
                .value
            
            return .success(categories)
        } catch {
            return .failure(error)
        }
    }
}
