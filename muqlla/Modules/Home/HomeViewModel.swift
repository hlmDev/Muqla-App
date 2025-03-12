//
//  HomeViewModel.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 11/03/2025.
//

import SwiftUI


class HomeViewModel: ObservableObject {
    
    let service = HomeServiceManager()
    
    @Published var categories: [BookCategory] = []
    @Published var loading = false
    
    @Published var books: [Book] = [
        Book(title: "Wish I Were My Alter Ego", author: "Alanoud Alsamil", status: "Incomplete", color: .blue),
        Book(title: "Joseph Stalin's Vision of Socialism", author: "Alanoud Alsamil", status: "Complete", color: .purple),
        Book(title: "Nietzsche's Morality", author: "Alanoud Alsamil", status: "Incomplete", color: .green),
        Book(title: "In Which Mental Stage Is Your Mind Stuck?", author: "Alanoud Alsamil", status: "Complete", color: .brown)
    ]

    @Published var searchText = ""
    @Published var selectedFilter = "All"

    let filters = ["All", "Complete", "Incomplete"]

    var filteredBooks: [Book] {
        books.filter { book in
            (selectedFilter == "All" || book.status == selectedFilter) &&
            (searchText.isEmpty || book.title.localizedCaseInsensitiveContains(searchText))
        }
    }
    
    
    @MainActor
    func fetchCategories() {
        loading = true
        Task {
            let result = await service.fetchCategories()
            switch result {
            case .success(let success):
                var _categories = success
                _categories.insert(BookCategory(id: -1, name: "All", isSelected: true), at: 0)
                categories = _categories
                loading = false
            case .failure(let failure):
                loading = false
                print("failure, \(failure.localizedDescription)")
            }
        }
    }
    func unselectAllCategories() {
        categories.indices.forEach{categories[$0].isSelected = false}
    }
}
