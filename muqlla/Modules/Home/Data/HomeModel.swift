//
//  Model.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 11/03/2025.
//

import SwiftUI


struct BookCategory: Codable, Identifiable {
    let id: Int
    let name: String
    
    var isSelected = false
    
    var textColor: Color {
        isSelected ? .cPrimaryText : .cMuted
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "category_id"
        case name = "category_name"
    }
}
