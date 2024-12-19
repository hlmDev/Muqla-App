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

    @Published var permissionStatus: Bool = false
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""

    init() {
        getiCloudUser()
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

    func saveUserToCloudKit(credential: ASAuthorizationAppleIDCredential) {
        let record = CKRecord(recordType: "User")
        record["appleUserIdentifier"] = credential.user
        record["email"] = credential.email

        if let fullName = credential.fullName {
            record["givenName"] = fullName.givenName
            record["familyName"] = fullName.familyName
        }

        container.publicCloudDatabase.save(record) { [weak self] _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.error = "Unable to save your information. Please try again."
                    print("Error saving to CloudKit: \(error)")
                } else {
                    print("Successfully saved user to CloudKit")
                }
            }
        }
    }
}

class BookViewModel: ObservableObject {
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
}
