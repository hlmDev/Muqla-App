// Views.swift
// muqlla
// Created by Ahlam Majed on 19/12/2024.

import SwiftUICore
import SwiftUI
import _AuthenticationServices_SwiftUI

struct KitSplash: View {
    @StateObject private var vm = CloudKitUserViewModel()
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 30) {
                    HStack {
                        Spacer()
                        Button("Skip") {
                            navigateToHome = true
                        }
                        .foregroundColor(.white)
                        .padding()
                        .accessibilityLabel("Skip onboarding")
                        .accessibilityHint("Double tap to skip the introduction and proceed to the main app")
                    }

                    Spacer()

                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .accessibilityLabel("App logo pp logo An artistic drawing of an eye with a pencil")
                        .accessibilityHint("An artistic drawing of an eye with a pencil")

                    Spacer()

                    VStack(spacing: 16) {
                        Text("Step into a world of endless stories")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .accessibilityAddTraits(.isHeader)

                        Text("Co-write books with authors worldwide\nDiscover unique books born from collaboration.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.green)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Step into a world of endless stories. Co-write books with authors worldwide. Discover unique books born from collaboration.")
                    }

                    Spacer()

                    SignInWithAppleButton { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                                vm.saveUserToCloudKit(credential: appleIDCredential)
                                navigateToHome = true
                            }
                        case .failure(let error):
                            vm.error = "Sign in failed: \(error.localizedDescription)"
                        }
                    }
                    .signInWithAppleButtonStyle(.white)
                    .frame(height: 50)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                    .accessibilityLabel("Sign in with Apple")
                    .accessibilityHint("Double tap to sign in using your Apple ID. This will request access to your name and email")
                    .accessibilityAddTraits(.isButton)
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomePageView()
                    .navigationBarBackButtonHidden(true)
            }
            .alert("Error", isPresented: .constant(!vm.error.isEmpty)) {
                Button("OK") {
                    vm.error = ""
                }
                .accessibilityLabel("Dismiss error")
                .accessibilityHint("Double tap to close this error message")
            } message: {
                Text(vm.error)
            }
        }
    }
}

struct HomePageView: View {
    @StateObject private var bookVM = BookViewModel()
    @State private var selectedTab = "home"

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeContentView(bookVM: bookVM)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag("home")
            .accessibilityLabel("Home tab")
            .accessibilityHint("View all books")

            NavigationStack {
                WriteBookView()
            }
            .tabItem {
                Image(systemName: "pencil")
                Text("Write")
            }
            .tag("write")
            .accessibilityLabel("Write tab")
            .accessibilityHint("Write a new book")

            NavigationStack {
                Text("Profile View")
            }
            .tabItem {
                Image(systemName: "person.circle.fill")
                Text("Profile")
            }
            .tag("profile")
            .accessibilityLabel("Profile tab")
            .accessibilityHint("View your profile information")
        }
        .accentColor(.green)
    }
}

struct HomeContentView: View {
    @ObservedObject var bookVM: BookViewModel

    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $bookVM.searchText)
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

            HStack {
                ForEach(bookVM.filters, id: \ .self) { filter in
                    Button(action: {
                        bookVM.selectedFilter = filter
                    }) {
                        Text(filter)
                            .foregroundColor(bookVM.selectedFilter == filter ? .black : .white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(bookVM.selectedFilter == filter ? Color.green : Color.gray.opacity(0.3))
                            .cornerRadius(20)
                    }
                    .accessibilityLabel("\(filter) filter")
                    .accessibilityHint("Show \(filter.lowercased()) books")
                    .accessibilityAddTraits(bookVM.selectedFilter == filter ? .isSelected : [])
                }
            }
            .padding(.horizontal)

            ScrollView {
                if bookVM.filteredBooks.isEmpty {
                    Text("No books found")
                        .foregroundColor(.gray)
                        .padding()
                        .accessibilityLabel("No books found")
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(bookVM.filteredBooks) { book in
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
}

struct BookCard: View {
    let title: String
    let author: String
    let status: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .accessibilityLabel("Title: \(title)")
            Text("By \(author)")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
                .accessibilityLabel("Author: \(author)")
            Spacer()
            Text(status)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .accessibilityLabel("Status: \(status)")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color.opacity(0.8))
        .cornerRadius(12)
    }
}

struct WriteBookView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var content = ""
    @State private var showCancelDialog = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    TextField("Title", text: $title)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top)
                        .accessibilityLabel("Book title")
                        .accessibilityHint("Enter the title of your book")

                    Text(Date(), style: .date)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .accessibilityLabel("Creation date")

                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $content)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(.systemGray5).opacity(0.2))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .accessibilityLabel("Book content")
                            .accessibilityHint("Write your book content here")
                        
                        if content.isEmpty {
                            Text("Type your Book..")
                                .foregroundColor(.gray)
                                .padding(.leading, 20)
                                .padding(.top, 8)
                                .accessibility(hidden: true)
                        }
                    }
                    .frame(height: 250)
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showCancelDialog = true
                    }
                    .foregroundColor(.green)
                    .accessibilityLabel("Cancel writing")
                    .accessibilityHint("Double tap to show save or delete options")
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Publish") {
                        if !title.isEmpty {
                            print("Book Published: \(title)")
                            dismiss()
                        }
                    }
                    .foregroundColor(title.isEmpty ? .gray : .green)
                    .disabled(title.isEmpty)
                    .accessibilityLabel("Publish book")
                    .accessibilityHint(title.isEmpty ? "Add a title first" : "Double tap to publish your book")
                }
            }
            .confirmationDialog("Select", isPresented: $showCancelDialog) {
                Button("Save to Draft") {
                    print("Saved as Draft")
                    dismiss()
                }

                Button("Delete", role: .destructive) {
                    print("Content Deleted")
                    dismiss()
                }

                Button("Cancel", role: .cancel) { }
            }
        }
    }
}
