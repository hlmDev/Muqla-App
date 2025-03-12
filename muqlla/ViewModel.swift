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

    init() {
        // Check if user has signed in before
        self.isNewUser = !UserDefaults.standard.bool(forKey: userKey)
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
                    // Mark user as signed in
                    UserDefaults.standard.set(true, forKey: self?.userKey ?? "")
                    self?.isNewUser = false
                }
            }
        }
    }

    // Function to check if user is signed in
    func checkUserSignInStatus() -> Bool {
        return !isNewUser
    }
}

class NovelViewModel: ObservableObject {
    @Published var novels: [Novel] = [
        Novel(id: 1, name: "Name", date: "2024-06-17", color: "purple"),
        Novel(id: 2, name: "Name", date: "2024-06-18", color: "blue"),
        Novel(id: 3, name: "Name", date: "2024-06-19", color: "purple")
    ]
    
    func deleteNovel(id: Int) {
        novels.removeAll { $0.id == id }
    }
}
