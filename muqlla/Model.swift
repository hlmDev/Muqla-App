//
//  Model.swift
//  muqlla
//
//  Created by Ahlam Majed on 19/12/2024.
//

import SwiftUI
import CloudKit
import AuthenticationServices
import AVFoundation

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
struct Books: Identifiable {
    let id: UUID
    var title: String
    var author: String
    var description: String
    var textContent: String // النص الكامل للكتاب
}
