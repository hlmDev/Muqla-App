// Views.swift
// muqlla
// Created by Ahlam Majed on 19/12/2024.

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
                HomeView()
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
        
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 15) {
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
                                .padding(.top, 24)
                                .accessibility(hidden: true)
                        }
                    }
                  //  .frame(height: 250)
                    
                    Spacer()
                }
                .padding(.top)
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

