// Created by Ahlam Majed on 19/12/2024.

// Views.swift
// muqlla
// Created by Ahlam Majed on 19/12/2024.

import SwiftUICore
import SwiftUI
import _AuthenticationServices_SwiftUI
import CloudKit


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
    @StateObject private var cloudKitVM = CloudKitUserViewModel()
    @State private var showNamePrompt = false
    @State private var selectedTab = "home"

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeContentView(bookVM: bookVM)
                    .onAppear {
                        // Refresh books when tab appears
                        bookVM.fetchBooks()
                    }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag("home")

            NavigationStack {
                WriteBookView()
            }
            .tabItem {
                Image(systemName: "pencil")
                Text("Write")
            }
            .tag("write")

            NavigationStack {
                NovelListView()
            }
            .tabItem {
                Image(systemName: "person.circle.fill")
                Text("Profile")
            }
            .tag("profile")
        }
        .accentColor(.green)
        .onAppear {
            if cloudKitVM.authorName.isEmpty {
                showNamePrompt = true
            }
            // Initial fetch of books
            bookVM.fetchBooks()
        }
        .sheet(isPresented: $showNamePrompt) {
            AuthorNameView(viewModel: cloudKitVM, showNamePrompt: $showNamePrompt)
        }
    }
}

//struct HomeContentView: View {
//  @ObservedObject var bookVM: BookViewModel
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                HStack {
//                    TextField("Search", text: $bookVM.searchText)
//                        .padding(10)
//                        .background(Color(.systemGray5).opacity(0.2))
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                        .accessibilityLabel("Search books")
//                        .accessibilityHint("Enter text to search for books")
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(.white)
//                        .accessibilityLabel("Search")
//                }
//                .padding(.horizontal)
//
//                HStack {
//                    ForEach(bookVM.filters, id: \.self) { filter in
//                        Button(action: {
//                            bookVM.selectedFilter = filter
//                        }) {
//                            Text(filter)
//                                .foregroundColor(bookVM.selectedFilter == filter ? .black : .white)
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 15)
//                                .background(bookVM.selectedFilter == filter ? Color.green : Color.gray.opacity(0.3))
//                                .cornerRadius(20)
//                        }
//                        .accessibilityLabel("\(filter) filter")
//                        .accessibilityHint("Show \(filter.lowercased()) books")
//                        .accessibilityAddTraits(bookVM.selectedFilter == filter ? .isSelected : [])
//                    }
//                }
//                .padding(.horizontal)
//
//                ScrollView {
//                    if bookVM.filteredBooks.isEmpty {
//                        Text("No books found")
//                            .foregroundColor(.gray)
//                            .padding()
//                            .accessibilityLabel("No books found")
//                    } else {
//                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
//                            ForEach(bookVM.filteredBooks) { book in
//                                BookCard(
//                                    title: book.title,
//                                    author: book.author,
//                                    status: book.status,
//                                    color: book.color,
//                                    destination: BookProfileView() // Navigate to BookProfileView
//                                )
//                                .frame(height: 200)
//                                .accessibilityElement(children: .combine)
//                                .accessibilityLabel("\(book.title) by \(book.author)")
//                                .accessibilityHint("Status: \(book.status)")
//                            }
//                        }
////                        .padding()
//                    }
//                }
//            }
////            .navigationTitle("")
//        }
//    }
//}

struct HomeContentView: View {
    @ObservedObject var bookVM: BookViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Search and Filter Section
                VStack(spacing: 16) {
                    HStack {
                        TextField("Search", text: $bookVM.searchText)
                            .padding(10)
                            .background(Color(.systemGray5).opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(bookVM.filters, id: \.self) { filter in
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
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                if bookVM.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(bookVM.filteredBooks) { book in
                                NavigationLink(destination: BookProfileView(book: book)) {
                                    BookCard(
                                        title: book.title,
                                        author: book.author,
                                        status: book.status,
                                        color: book.displayColor,
                                        visibilityBadge: book.visibilityBadge
                                    )
                                    .frame(height: 200)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            
            .onAppear {
                          bookVM.fetchBooks()  // Add this to refresh when view appears
                      }
        }
    }
}


//struct BookCard<Destination: View>: View {
//    let title: String
//    let author: String
//    let status: String
//    let color: Color
//    let destination: Destination
//
//    var body: some View {
//        NavigationLink(destination: destination) {
//            VStack(alignment: .leading, spacing: 5) {
//                Text(title)
//                    .font(.title3)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .accessibilityLabel("Title: \(title)")
//                Text("By \(author)")
//                    .font(.footnote)
//                    .foregroundColor(.white.opacity(0.7))
//                    .accessibilityLabel("Author: \(author)")
//                Spacer()
//                Text(status)
//                    .font(.caption)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .accessibilityLabel("Status: \(status)")
//            }
//            .padding()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(color.opacity(0.8))
//            .cornerRadius(12)
//        }
//        .buttonStyle(PlainButtonStyle()) // Keeps the custom appearance
//    }
//}
//

struct BookCard: View {
    let title: String
    let author: String
    let status: String
    let color: Color
    let visibilityBadge: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(2)
            
            Text("By \(author)")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            HStack {
                Text(status)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(visibilityBadge)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(getBadgeColor(visibilityBadge))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color.opacity(0.8))
        .cornerRadius(12)
    }
    
    private func getBadgeColor(_ badge: String) -> Color {
        switch badge {
        case "Draft": return .gray
        case "Collab": return .purple
        case "Published": return .green
        default: return .blue
        }
    }
}

//    struct WriteBookView: View {
//        @Environment(\.dismiss) private var dismiss
//        @StateObject private var cloudKitVM = CloudKitUserViewModel()
//        @StateObject private var bookVM = BookViewModel()
//        @State private var title = ""
//        @State private var content = ""
//        @State private var showCancelDialog = false
//        @State private var navigateToHome = false
//
//        func saveBook() {
//            let container = CKContainer(identifier: "iCloud.com.a.muqlla")
//            let record = CKRecord(recordType: "Book")
//
//            // here important
//            let authorRecordID = CKRecord.ID(recordName: cloudKitVM.authorName)
//            let authorReference = CKRecord.Reference(recordID: authorRecordID, action: .none)
//
//            record["author"] = authorReference
//
//            record["title"] = title
//            record["content"] = content
//            record["author"] = authorReference
//            record["createdAt"] = Date()
//            record["status"] = "Published"  // Or "Draft" based on your needs
//            record["isDraft"] = 0
//            record["collaborators"] = [authorReference]
//
//            print("Saving book with title: \(title)")
//
//            container.publicCloudDatabase.save(record) { record, error in
//                DispatchQueue.main.async {
//                    if let error = error {
//                        print(" CloudKit save error: \(error.localizedDescription)")
//                        return
//                    }
//                    print("Book saved successfully")
//                    self.dismiss()
//                }
//            }
//        }
//
//        var body: some View {
//            NavigationView {
//                ZStack {
//                    Color.black.edgesIgnoringSafeArea(.all)
//
//                    VStack(alignment: .leading, spacing: 15) {
//                        TextField("Title", text: $title)
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding(.horizontal)
//                            .padding(.top)
//                            .accessibilityLabel("Book title")
//                            .accessibilityHint("Enter the title of your book")
//
//                        Text(Date(), style: .date)
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                            .padding(.horizontal)
//                            .accessibilityLabel("Creation date")
//
//                        ZStack(alignment: .topLeading) {
//                            TextEditor(text: $content)
//                                .foregroundColor(.white)
//                                .padding()
//                                .background(Color(.systemGray5).opacity(0.2))
//                                .cornerRadius(8)
//                                .padding(.horizontal)
//                                .accessibilityLabel("Book content")
//                                .accessibilityHint("Write your book content here")
//
//                            if content.isEmpty {
//                                Text("Type your Book..")
//                                    .foregroundColor(.gray)
//                                    .padding(.leading, 20)
//                                    .padding(.top, 24)
//                                    .accessibility(hidden: true)
//                            }
//                        }
//
//                        Spacer()
//                    }
//                    .padding(.top)
//                }
//                .navigationBarItems(
//                    leading: Button("Cancel") {
//                        showCancelDialog = true
//                    }
//                        .foregroundColor(.green)
//                        .accessibilityLabel("Cancel writing")
//                        .accessibilityHint("Double tap to show save or delete options"),
//
//                    trailing: Button("Publish") {
//                        if !title.isEmpty {
//                            saveBook()
//                        }
//                    }
//                        .foregroundColor(title.isEmpty ? .gray : .green)
//                        .disabled(title.isEmpty)
//                        .accessibilityLabel("Publish book")
//                        .accessibilityHint(title.isEmpty ? "Add a title first" : "Double tap to publish your book")
//                )
//                .confirmationDialog("Select", isPresented: $showCancelDialog) {
//                    Button("Save to Draft") {
//                        print("Saved as Draft")
//                        dismiss()
//                    }
//
//                    Button("Delete", role: .destructive) {
//                        print("Content Deleted")
//                        navigateToHome = true
//                    }
//
//                    Button("Cancel", role: .cancel) { }
//                }
//            }
//        }
//    }

struct AuthorNameView: View {
    @StateObject private var viewModel: CloudKitUserViewModel
    @State private var authorName: String = ""
    @Binding var showNamePrompt: Bool
    
    init(viewModel: CloudKitUserViewModel, showNamePrompt: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _showNamePrompt = showNamePrompt
    }
    

   
        
        var body: some View {
            NavigationView {
                VStack(spacing: 20) {
                    // Title Text
//                    Text("Enter Your Name")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding(.top, 20)
                    
                    // TextField for entering name
                    TextField("Enter Your Name", text: $authorName)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                        .padding(.horizontal)
                    
                    // Continue Button
                    Button(action: {
                        if !authorName.isEmpty {
                            viewModel.updateAuthorName(authorName)
                            showNamePrompt = false
                        }
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(authorName.isEmpty ? Color.gray : Color.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .disabled(authorName.isEmpty)
                    .padding(.horizontal)
                }
            }
        }
    }
