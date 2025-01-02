//
//  ViewModel.swift
//  muqlla
//
//  Created by Ahlam Majed on 19/12/2024.
//


import Foundation
import CloudKit
import AuthenticationServices
import SwiftUICore



class CloudKitUserViewModel: ObservableObject {
    private let container = CKContainer(identifier: "iCloud.com.a.muqlla")
    private let userKey = "userSignedIn" // Key to track if user has signed in before

    @Published var permissionStatus: Bool = false
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""
    @Published var isNewUser: Bool
    @Published var authorName: String = ""
    init() {
        // Check if user has signed in before
        self.isNewUser = !UserDefaults.standard.bool(forKey: userKey)
        getiCloudUser()
        loadAuthorName()
    }

    private func getiCloudUser() {
        container.accountStatus { [weak self] returnedStatus, _ in
            DispatchQueue.main.async {
                switch returnedStatus {
                case .available:
                    self?.isSignedInToiCloud = true
                    self?.requestPermission()
                    self?.fetchiCloudUserRecordID()
                case .noAccount:
                    self?.error = "No iCloud Account Found"
                case .couldNotDetermine:
                    self?.error = "iCloud Account Status Indeterminate"
                case .restricted:
                    self?.error = "iCloud Account Restricted"
                default:
                    self?.error = "Unknown iCloud Account Status"
                }
            }
        }
    }

    private func requestPermission() {
        container.requestApplicationPermission([.userDiscoverability]) { [weak self] returnedStatus, _ in
            DispatchQueue.main.async {
                if returnedStatus == .granted {
                    self?.permissionStatus = true
                }
            }
        }
    }

    private func fetchiCloudUserRecordID() {
        container.fetchUserRecordID { [weak self] returnedID, _ in
            if let id = returnedID {
                self?.discoveriCloudUser(id: id)
            }
        }
    }

    private func discoveriCloudUser(id: CKRecord.ID) {
        container.discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, _ in
            DispatchQueue.main.async {
                if let name = returnedIdentity?.nameComponents?.givenName {
                    self?.userName = name
                }
            }
        }
    }

//    func saveUserToCloudKit(credential: ASAuthorizationAppleIDCredential) {
//        let record = CKRecord(recordType: "User")
//        record["appleUserIdentifier"] = credential.user
//        record["email"] = credential.email
//
//        if let fullName = credential.fullName {
//            record["givenName"] = fullName.givenName
//            record["familyName"] = fullName.familyName
//        }
//
//        container.publicCloudDatabase.save(record) { [weak self] _, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self?.error = "Unable to save your information. Please try again."
//                    print("Error saving to CloudKit: \(error)")
//                } else {
//                    print("Successfully saved user to CloudKit")
//                    // Mark user as signed in
//                    UserDefaults.standard.set(true, forKey: self?.userKey ?? "")
//                    self?.isNewUser = false
//                }
//            }
//        }
//    }
    
    func saveUserToCloudKit(credential: ASAuthorizationAppleIDCredential, authorName: String? = nil) {
        let record = CKRecord(recordType: "User")
        record["appleUserIdentifier"] = credential.user
        record["email"] = credential.email
        record["name"] = authorName ?? credential.fullName?.givenName // Save author name

        if let fullName = credential.fullName {
            record["givenName"] = fullName.givenName
            record["familyName"] = fullName.familyName
        }

        container.publicCloudDatabase.save(record) { [weak self] savedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.error = "Unable to save your information. Please try again."
                    print("Error saving to CloudKit: \(error)")
                } else {
                    if let name = savedRecord?["name"] as? String {
                        self?.authorName = name
                        UserDefaults.standard.set(name, forKey: "authorName")
                    }
                    UserDefaults.standard.set(true, forKey: self?.userKey ?? "")
                    self?.isNewUser = false
                }
            }
        }
    }
    
    func updateAuthorName(_ name: String) {
           guard !name.isEmpty else { return }
           
           // Query for existing user record
           let predicate = NSPredicate(format: "appleUserIdentifier == %@", userName)
           let query = CKQuery(recordType: "User", predicate: predicate)
           
           container.publicCloudDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
               if let record = records?.first {
                   record["name"] = name
                   
                   self?.container.publicCloudDatabase.save(record) { savedRecord, error in
                       DispatchQueue.main.async {
                           if error == nil {
                               self?.authorName = name
                               UserDefaults.standard.set(name, forKey: "authorName")
                           }
                       }
                   }
               }
           }
       }

       private func loadAuthorName() {
           authorName = UserDefaults.standard.string(forKey: "authorName") ?? ""
       }
   

    // Function to check if user is signed in
    func checkUserSignInStatus() -> Bool {
        return !isNewUser
    }

}
// Rest of your ViewModels remain the same
//class BookViewModel: ObservableObject {
//    @Published var books: [Book] = [
//        Book(title: "Wish I Were My Alter Ego", author: "Alanoud Alsamil", status: "Incomplete", color: .blue),
////        Book(title: "Joseph Stalin's Vision of Socialism", author: "Alanoud Alsamil", status: "Complete", color: .purple),
////        Book(title: "Nietzsche's Morality", author: "Alanoud Alsamil", status: "Incomplete", color: .green),
////        Book(title: "In Which Mental Stage Is Your Mind Stuck?", author: "Alanoud Alsamil", status: "Complete", color: .brown)
//    ]
//
//    @Published var searchText = ""
//    @Published var selectedFilter = "All"
//
//    let filters = ["All", "Complete", "Incomplete"]
//
//    var filteredBooks: [Book] {
//        books.filter { book in
//            (selectedFilter == "All" || book.status == selectedFilter) &&
//            (searchText.isEmpty || book.title.localizedCaseInsensitiveContains(searchText))
//        }
//    }
//}

class BookViewModel: ObservableObject {
    private let container = CKContainer(identifier: "iCloud.com.a.muqlla")
    @Published var books: [Book] = []
    @Published var searchText = ""
    @Published var selectedFilter = "All"
    @Published var isLoading = false
    @Published var error: String = ""
    
    let filters = ["All", "Complete", "Incomplete"]
    
    init() {
        setupCurrentUserReference()
    }
    
    private func setupCurrentUserReference() {
        guard let authorName = UserDefaults.standard.string(forKey: "authorName") else {
            print("⚠️ No author name found")
            return
        }
        print("📚 Author name found: \(authorName)")
        fetchBooks()
    }
    
    func fetchBooks() {
        isLoading = true
        print("🔄 Fetching books...")
        
        // Simple predicate to get all books
        let query = CKQuery(recordType: "Book", predicate: NSPredicate(value: true))
        
        container.publicCloudDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    print("❌ Error fetching books: \(error.localizedDescription)")
                    self?.error = error.localizedDescription
                    return
                }
                
                guard let records = records else {
                    print("⚠️ No records found")
                    self?.error = "No books found"
                    return
                }
                
                print("✅ Found \(records.count) books")
                
                // Reset books array before adding new ones
                self?.books = records.map { record in
                    let title = record["title"] as? String ?? "Untitled"
                    let status = record["status"] as? String ?? "Incomplete"
                    let isDraft = record["isDraft"] as? Int ?? 0
                    let authorRef = record["author"] as? CKRecord.Reference
                    let authorName = authorRef?.recordID.recordName ?? "Unknown Author"
                    
                    print("📖 Loading book: \(title) by \(authorName)")
                    
                    return Book(
                        id: record.recordID.recordName,
                        title: title,
                        author: authorName,
                        status: status,
                        color: .blue,
                        isDraft: isDraft,
                        isCollaborative: (record["collaborators"] as? [CKRecord.Reference])?.count ?? 0 > 1,
                        description: record["description"] as? String
                    )
                }
                
                print("📚 Total books loaded: \(self?.books.count ?? 0)")
            }
        }
    }
    
    var filteredBooks: [Book] {
        books.filter { book in
            let matchesFilter = selectedFilter == "All" || book.status == selectedFilter
            let matchesSearch = searchText.isEmpty || book.title.localizedCaseInsensitiveContains(searchText)
            return matchesFilter && matchesSearch
        }
    }
}



class NovelViewModel: ObservableObject {
    @Published var novels: [Novel] = []
    @Published var isLoading: Bool = false
    @Published var error: String = ""  // Added error property
    private let container = CKContainer(identifier: "iCloud.com.a.muqlla")
    
    init() {
        fetchBooks()
    }
    
    func fetchBooks() {
        isLoading = true
        let query = CKQuery(recordType: "Book", predicate: NSPredicate(value: true))
        
        container.publicCloudDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.error = error.localizedDescription
                    print("CloudKit error: \(error.localizedDescription)")
                    return
                }
                
                guard let records = records else {
                    self?.error = "No records found"
                    return
                }
                
                self?.novels = records.map { record in
                    Novel(
                        id: record.recordID.hashValue,
                        name: record["title"] as? String ?? "",
                        date: (record["date"] as? Date)?.formatted() ?? "",
                        color: "blue"
                    )
                }
            }
        }
    }
    
    func deleteNovel(id: Int) {
        novels.removeAll { $0.id == id }
    }
}


//class NovelViewModel: ObservableObject {
//    @Published var novels: [Novel] = [
//        Novel(id: 1, name: "Name", date: "2024-06-17", color: "purple"),
//        Novel(id: 2, name: "Name", date: "2024-06-18", color: "blue"),
//        Novel(id: 3, name: "Name", date: "2024-06-19", color: "purple")
//    ]
//
//    func deleteNovel(id: Int) {
//        novels.removeAll { $0.id == id }
//    }
//}


