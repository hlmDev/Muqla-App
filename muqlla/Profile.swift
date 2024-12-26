//
//  Profile.swift
//  muqlla
//
//  Created by Ahlam Majed on 19/12/2024.
//

import SwiftUI
import SwiftUICore
import _AuthenticationServices_SwiftUI
import CloudKit

//struct NovelListView: View {
//    @StateObject private var viewModel = NovelViewModel()
//    @State private var selectedTab = 0
//    @State private var selectedNavIndex = 2// Tracks bottom bar selection
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                // Top Tabs
//                TopTabsView(selectedTab: $selectedTab)
//                
//                // List of Novels
//                ScrollView {
//                    VStack(spacing: 15) {
//                        ForEach(viewModel.novels) { novel in
//                            NovelRowView(novel: novel, selectedTab: selectedTab, deleteAction: {
//                                viewModel.deleteNovel(id: novel.id) // Call delete function
//                            })
//                        }
//                    }
//                   // .padding(.top, 10)
//                }
//                .background(Color.black)
//                
//                // Bottom Navigation Bar
//               // BottomNavBarView(selectedNavIndex: $selectedNavIndex)
//            }
//            .navigationBarHidden(true)
//            .background(Color.black)
//        }
//        .preferredColorScheme(.dark)
//    }
//}

struct NovelListView: View {
    @StateObject private var viewModel = NovelViewModel()
    @State private var selectedTab = 0
    @State private var selectedNavIndex = 2
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TopTabsView(selectedTab: $selectedTab)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.novels) { novel in
                            NovelRowView(novel: novel, selectedTab: selectedTab, deleteAction: {
                                viewModel.deleteNovel(id: novel.id)
                            })
                        }
                    }
                }
                .background(Color.black)
            }
            .navigationBarHidden(true)
            .background(Color.black)
        }
        .onAppear {
            viewModel.fetchBooks()
        }
        .preferredColorScheme(.dark)
      
    }
}

//class NovelViewModel: ObservableObject {
//    @Published var novels: [Novel] = []
//    private let container = CKContainer(identifier: "iCloud.com.a.muqlla")
//    
//    func fetchBooks() {
//        let query = CKQuery(recordType: "Book", predicate: NSPredicate(value: true))
//        
//        container.publicCloudDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
//            DispatchQueue.main.async {
//                guard let records = records, error == nil else { return }
//                
//                self?.novels = records.map { record in
//                    Novel(
//                        id: record.recordID.hashValue,
//                        name: record["title"] as? String ?? "",
//                        date: (record["date"] as? Date)?.formatted() ?? "",
//                        color: "blue"
//                    )
//                }
//            }
//        }
//    }
//    
//    func deleteNovel(id: Int) {
//        novels.removeAll { $0.id == id }
//    }
//}

// MARK: - Top Tabs View
struct TopTabsView: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 12) {
            TabButton(title: NSLocalizedString("Drafts", comment: "") , isSelected: selectedTab == 0, selectedColor: .green, defaultBackground: Image("darkgray"))
                .onTapGesture { selectedTab = 0 }

            TabButton(title: NSLocalizedString("Collabs", comment: "") , isSelected: selectedTab == 1, selectedColor: .green, defaultBackground: Image("darkgray"))
                .onTapGesture { selectedTab = 1 }

            TabButton(title: NSLocalizedString("Publish", comment: "") , isSelected: selectedTab == 2, selectedColor: .green, defaultBackground: Image("darkgray"))
                .onTapGesture { selectedTab = 2 }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}


// MARK: - TabButton View
struct TabButton: View {
    var title: String
    var isSelected: Bool
    var selectedColor: Color
    var defaultBackground: Image

    var body: some View {
        Text(title)
            .fontWeight(.medium)
            .foregroundColor(isSelected ? .white : .primary) // White text for selected, primary for unselected
            .padding(.horizontal, 20) // Adjust horizontal padding
            .padding(.vertical, 10)   // Adjust vertical padding
            .background(
                ZStack {
                    if isSelected {
                        selectedColor // Green background for selected
                    } else {
                        defaultBackground
                            .resizable()
                            .scaledToFill() // Ensure the image fills the space
                    }
                }
            )
            .clipShape(Capsule()) // Rounded pill shape
    }
}

// MARK: - Novel Row View
struct NovelRowView: View {
    let novel: Novel
    let selectedTab: Int
    let deleteAction: () -> Void
    
    var body: some View {
        ZStack {
            // Background Box
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("darkgrayy"))
                .frame(width: 375.0, height: 128)
            
            HStack {
                // Book Rectangle
                Rectangle()
                    .fill(colorForName(novel.color))
                    .frame(width: 70, height: 90)
                    .cornerRadius(8)
                    .padding(.leading, 20)
//                    .padding(.leading, 70)
                    
                    .padding(.leading, selectedTab == 0 ? -40 : -25)
                    .padding(.leading, selectedTab != 2 ? 2 : -165)
                    .padding(.leading, selectedTab != 1 ? 2 : -165)

                
                    .accessibilityLabel("Book Image")
                


                // Book Information
                VStack/*(alignment: .leading, spacing: 10)*/ {
                    
                    Text(novel.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top,-30)
                        .padding(.leading, selectedTab != 2 ? 2 : -100)
                        .padding(.leading, selectedTab != 1 ? 2 : -100)

//                        .padding(.leading, selectedTab == 2 ? 2 : -100)
//                        .padding(.leading, -50)
                        .accessibilityLabel("Book Name")
                    Text(Date(), style: .date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.leading, selectedTab != 2 ? 2 : -90)
                        .padding(.leading, selectedTab != 1 ? 2 : -90)

//                        .padding(.leading, -20)
                        .accessibilityLabel("Book Date")
                        
                }
                
//                Spacer()
                
                HStack  {
                 
//                    if selectedTab == 0 || selectedTab == 1  {
//                        Button(action: { }) {
//                            Text("Edit")
//                                .font(.body)
//                                .fontWeight(.medium)
//                                .foregroundColor(.white)
//                                .frame(width: selectedTab == 1 ? 180 : 100, height: 30) // Custom size for Collabs
//                                .background(Color.gray.opacity(0.8)) // Custom color for Collabs
//                                .cornerRadius(8)
//                                .padding(.top, 80)
//                                .padding(.leading, selectedTab == 0 ? -30 : -10)
//                                .accessibilityLabel("Edit")
//                                .accessibilityAddTraits(.isButton)
//                        }
//                    }
//                    
                    if selectedTab == 0 {
                        Button(action: { deleteAction() }) { // Call deleteAction on tap
                            Text("Delete")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(width: 180, height: 30)
                                .background(Color.gray.opacity(0.8))
                                .cornerRadius(8)
                                .padding(.top, 80)
                                .padding(.leading,-30)
                                .accessibilityLabel("Delete")
                                .accessibilityAddTraits(.isButton)
                            
//                                .padding(.leading, selectedTab != 1 ? -50 : -50)
                        }
                    }
                }
            }
        }
    }
    
    private func colorForName(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "purple": return Color.purple
        case "blue": return Color.blue
        default: return Color.gray
        }
    }
}

// MARK: - Bottom Navigation Bar
/*struct BottomNavBarView: View {
    @Binding var selectedNavIndex: Int
    
    var body: some View {
        ZStack {
            HStack {
                BottomNavButton(iconName: "house.fill", title: "Home", isSelected: selectedNavIndex == 0)
                    .accessibilityLabel("Home")
                                        .accessibilityAddTraits(.isButton)
                    .onTapGesture { selectedNavIndex = 0 }
                    
                Spacer()
                
                BottomNavButton(iconName: "pencil", title: "Write", isSelected: selectedNavIndex == 1)
                    .accessibilityLabel("Write")
                    .accessibilityAddTraits(.isButton)
                    .onTapGesture { selectedNavIndex = 1 }

                Spacer()
                
                BottomNavButton(iconName: "person.crop.circle", title: "Profile", isSelected: selectedNavIndex == 2)
                    .accessibilityLabel("Profile")
                                        .accessibilityAddTraits(.isButton)
                    .onTapGesture { selectedNavIndex = 2 }
                    
            }
            .padding(.horizontal)
        }
    }
}

struct BottomNavButton: View {
    let iconName: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: iconName)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? Color.green : Color.gray)
//                .accessibilityLabel("\(title) icon")
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? Color.white : Color.gray)
//                .accessibilityLabel("\(title) button")
        }
        .padding(.top, 10)
    }
}
*/
// MARK: - Preview
//struct NovelListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NovelListView()
//    }
//}
