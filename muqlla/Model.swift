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
    let id: String
    let title: String
    let author: String
    let status: String
    let color: Color
    let isDraft: Int
    let isCollaborative: Bool
    let description: String?
    let content: String?
    
    
    // Computed property for visibility badge
    var visibilityBadge: String {
        if isDraft == 1 {
            return "Draft"
        } else if isCollaborative {
            return "Collab"
        } else {
            return "Published"
        }
    }
    
    // Computed property for display color
    var displayColor: Color {
        if isDraft == 1 {
            return .gray
        } else if isCollaborative {
            return .purple
        } else {
            return color
        }
    }
    
    
    // Initialize from CloudKit record
    init(record: CKRecord) {
        self.id = record.recordID.recordName
        self.title = record["title"] as? String ?? ""
        self.status = record["status"] as? String ?? "Incomplete"
        self.isDraft = record["isDraft"] as? Int ?? 0
        self.description = record["description"] as? String
        self.content = record["content"] as? String // Add this
        
        
        
        if let authorRef = record["author"] as? CKRecord.Reference {
            self.author = authorRef.recordID.recordName
        } else {
            self.author = "Unknown Author"
        }
        
        self.isCollaborative = (record["collaborators"] as? [CKRecord.Reference])?.count ?? 0 > 1
        self.color = .blue  // Default color
    }
    
    // Initialize for static data (testing)
    init(id: String = UUID().uuidString,
         title: String,
         author: String,
         status: String,
         color: Color,
         isDraft: Int = 0,
         isCollaborative: Bool = false,
         description: String? = nil,
         content: String? = nil)
    {
        self.id = id
        self.title = title
        self.author = author
        self.status = status
        self.color = color
        self.isDraft = isDraft
        self.isCollaborative = isCollaborative
        self.description = description
        self.content = content
    }


    
//    struct Novel: Identifiable {
//        let id: Int
//        let name: String
//        let date: String
//        let color: String
//
//    }
    
    struct Novel: Identifiable {
        var id: Int
        var name: String
        var date: String
        var color: String
    }

    struct Books: Identifiable {
        let id: UUID
        var title: String
        var author: String
        var description: String
        var textContent: String // النص الكامل للكتاب
    }
    
}
