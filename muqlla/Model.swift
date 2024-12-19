//
//  Model.swift
//  muqlla
//
//  Created by Ahlam Majed on 19/12/2024.
//

import SwiftUI
import CloudKit
import AuthenticationServices

struct Book: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let status: String
    let color: Color
    
}
struct Novel: Identifiable {
    let id: Int
    let name: String
    let date: String
    let color: String

    
}
