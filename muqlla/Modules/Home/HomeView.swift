//
//  HomeView.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 11/03/2025.
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    welcomeView
                    searchView
                    categoriesView
                    booksView
                }
            }
        }
        .onAppear {
            viewModel.fetchCategories()
        }
        .onChange(of: viewModel.loading) {
            print(viewModel.loading)
        }
    }
    
    var welcomeView: some View {
        HStack {
            ZStack {
                Color.purple
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                MQText("MF")
            }
            MQText("Welcome")
            Spacer()
        }
        .padding(.leading, 15)
    }
    
    var searchView: some View {
        HStack {
            TextField("Search", text: $viewModel.searchText)
                .padding(10)
                .background(Color(.systemGray5).opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(8)
                .accessibilityLabel("Search books")
                .accessibilityHint("Enter text to search for books")
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white)
                .accessibilityLabel("Search")
        }
        .padding(.horizontal)
    }
    
    var categoriesView: some View {
        VStack {
            MQText(
                "Categories",
                .defaultFont(size: 20),
                color: .cPrimaryText
            )
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 30) {
                    ForEach(viewModel.categories.indices, id: \.self) { index in
                        MQButton {
                            viewModel.unselectAllCategories()
                            viewModel.categories[index].isSelected = true
                        } label: {
                            MQText(viewModel.categories[index].name,
                                   .defaultFont(size: 18),
                                   color: viewModel.categories[index].textColor)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 50)
        }
    }
    
    var booksView: some View {
        ScrollView {
            if viewModel.filteredBooks.isEmpty {
                Text("No books found")
                    .foregroundColor(.gray)
                    .padding()
                    .accessibilityLabel("No books found")
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(viewModel.filteredBooks) { book in
                        BookCard(title: book.title, author: book.author, status: book.status, color: book.color)
                            .frame(height: 200)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(book.title) by \(book.author)")
                            .accessibilityHint("Status: \(book.status)")
                    }
                }
                .padding()
            }
        }
    }
}


#Preview {
    HomeView()
}
