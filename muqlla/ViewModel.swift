//
//  ViewModel.swift
//  muqlla
//
//  Created by Ahlam Majed on 19/12/2024.
//


import Foundation
import CloudKit
import AuthenticationServices

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
class BookViewModel: ObservableObject {
    @Published var books: [Book] = [
        Book(title: "Wish I Were My Alter Ego", author: "Alanoud Alsamil", status: "Incomplete", color: .blue),
//        Book(title: "Joseph Stalin's Vision of Socialism", author: "Alanoud Alsamil", status: "Complete", color: .purple),
//        Book(title: "Nietzsche's Morality", author: "Alanoud Alsamil", status: "Incomplete", color: .green),
//        Book(title: "In Which Mental Stage Is Your Mind Stuck?", author: "Alanoud Alsamil", status: "Complete", color: .brown)
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
}


class NovelViewModel: ObservableObject {
    @Published var novels: [Novel] = []
    private let container = CKContainer(identifier: "iCloud.com.a.muqlla")
    
    init() {
        fetchBooks()
    }
    
    func fetchBooks() {
        let query = CKQuery(recordType: "Book", predicate: NSPredicate(value: true))
        container.publicCloudDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
            if let error = error {
                print("CloudKit error: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                guard let records = records else { return }
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


