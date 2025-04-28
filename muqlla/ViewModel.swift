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

// 1. First, let's modify the BookViewModel to filter out drafts from the home view
class BookViewModel: ObservableObject {
    private let container = CKContainer(identifier: "iCloud.com.a.muqlla")
    @Published var books: [Book] = []
    @Published var searchText = ""
    @Published var selectedFilter = "All"
    @Published var isLoading = false
    @Published var error: String = ""
    
    let filters = ["All", "Complete", "Incomplete"]
    private var currentUserName: String = ""
    
    init() {
        currentUserName = UserDefaults.standard.string(forKey: "authorName") ?? ""
        print("👤 Current user: \(currentUserName)")
    }
    
    func fetchBooks() {
        isLoading = true
        print("🔄 Fetching books...")
        
        // Query all non-draft books only
        let query = CKQuery(recordType: "Book", predicate: NSPredicate(value: true))
        
        container.publicCloudDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ Error fetching books: \(error.localizedDescription)")
                    self.error = error.localizedDescription
                    return
                }
                
                guard let records = records else {
                    print("⚠️ No records found")
                    self.error = "No books found"
                    return
                }
                
                print("✅ Found \(records.count) total records")
                
                self.books = records.compactMap { record in
                    let isDraft = (record["isDraft"] as? Int) ?? 0
                    
                    // Skip all drafts in home view
                    guard isDraft == 0 else { return nil }
                    
                    let title = record["title"] as? String ?? "Untitled"
                    let authorRef = record["author"] as? CKRecord.Reference
                    let authorName = authorRef?.recordID.recordName ?? "Unknown Author"
                    let isCollab = (record["collaborators"] as? [CKRecord.Reference])?.count ?? 0 > 1
                    
                    print("📖 Loading book: \(title) by \(authorName)")
                    
                    return Book(
                        id: record.recordID.recordName,
                        title: title,
                        author: authorName,
                        status: isDraft == 1 ? "Draft" : "Published",
                        color: isCollab ? .purple : .blue,
                        isDraft: isDraft,
                        isCollaborative: isCollab,
                        description: record["description"] as? String,
                        content: record["content"] as? String
                    )
                }
                
                print("📚 Successfully loaded \(self.books.count) published books")
            }
        }
    }
    
    var filteredBooks: [Book] {
        books.filter { book in
            let matchesFilter = selectedFilter == "All" || book.status == selectedFilter
            let matchesSearch = searchText.isEmpty || book.title.localizedCaseInsensitiveContains(searchText)
            // Ensure no drafts appear in filtered results
            return matchesFilter && matchesSearch && book.isDraft == 0
        }
    }
}

// 2. Update NovelViewModel to handle draft deletion
class NovelViewModel: ObservableObject {
    @Published var novels: [Novel] = []
    @Published var isLoading: Bool = false
    @Published var error: String = ""
    @Published var currentTab: Int = 0

    private let container = CKContainer(identifier: "iCloud.com.a.muqlla")
    private var currentUserName: String = ""
    private var recordIDs: [Int: CKRecord.ID] = [:]
    
    init() {
        currentUserName = UserDefaults.standard.string(forKey: "authorName") ?? ""
        print("👤 Current user in NovelViewModel: \(currentUserName)")
    }
    
    func fetchBooks(forTab selectedTab: Int) {
        isLoading = true
        print("🔄 Fetching books for tab: \(selectedTab)")
        
        // Only fetch if we're on the Drafts tab (tab 0)
        if selectedTab != 0 {
            novels = []  // Clear novels for other tabs
            isLoading = false
            return
        }
        
        let query = CKQuery(recordType: "Book", predicate: NSPredicate(value: true))
        
        container.publicCloudDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    print("❌ Error fetching drafts: \(error.localizedDescription)")
                    self.error = "Failed to fetch drafts: \(error.localizedDescription)"
                    return
                }
                
                guard let records = records else {
                    print("⚠️ No records found")
                    return
                }
                
                print("✅ Found \(records.count) total records")
                
                // Clear existing record IDs
                self.recordIDs.removeAll()
                
                // Only show drafts in the drafts tab
                self.novels = records.compactMap { record in
                    let isDraft = (record["isDraft"] as? Int) ?? 0
                    let authorRef = record["author"] as? CKRecord.Reference
                    let authorName = authorRef?.recordID.recordName ?? ""
                    
                    // Only include drafts by current user
                    guard isDraft == 1 && authorName == self.currentUserName else { return nil }
                    
                    let title = record["title"] as? String ?? ""
                    let id = record.recordID.hashValue
                    
                    // Store the record ID
                    self.recordIDs[id] = record.recordID
                    
                    print("📖 Loading draft: \(title)")
                    
                    return Novel(
                        id: id,
                        name: title,
                        date: Date().formatted(),
                        color: "blue"
                    )
                }
                
                print("📚 Successfully loaded \(self.novels.count) drafts")
            }
        }
    }
    
    func deleteNovel(id: Int) {
          print("🗑 Starting deletion process...")
          print("📝 Attempting to delete novel with ID: \(id)")
          
          // Get the stored record ID
          guard let recordID = recordIDs[id] else {
              print("❌ No record ID found for novel with ID: \(id)")
              return
          }
          
          // Log current state
          print("📊 Current novels count: \(novels.count)")
          
          // Remove from local array and verify removal
          novels.removeAll { $0.id == id }
          print("✅ Removed from local array. New count: \(novels.count)")
          
          print("🔄 Deleting CloudKit record: \(recordID.recordName)")
          
          container.publicCloudDatabase.delete(withRecordID: recordID) { [weak self] (deletedRecordID, error) in
              DispatchQueue.main.async {
                  if let error = error {
                      print("❌ CloudKit deletion error: \(error.localizedDescription)")
                      self?.error = "Failed to delete draft: \(error.localizedDescription)"
                      print("🔄 Refreshing books list due to error...")
                      self?.fetchBooks(forTab: self?.currentTab ?? 0)  // Use stored tab value
                  } else {
                      print("✅ CloudKit deletion successful")
                      print("🗑 Removed record ID: \(recordID.recordName)")
                      // Remove the record ID from storage
                      self?.recordIDs.removeValue(forKey: id)
                      print("✅ Cleanup completed")
                      
                      // Refresh the list
                      self?.fetchBooks(forTab: self?.currentTab ?? 0)  // Use stored tab value
                      
                      // Verify final state
                      print("📊 Final novels count: \(self?.novels.count ?? 0)")
                  }
              }
          }
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


