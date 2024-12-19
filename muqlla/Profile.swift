//
//  Profile.swift
//  muqlla
//
//  Created by Ahlam Majed on 19/12/2024.
//

import SwiftUI

struct NovelListView: View {
    @StateObject private var viewModel = NovelViewModel()
    @State private var selectedTab = 0
    @State private var selectedNavIndex = 2// Tracks bottom bar selection
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top Tabs
                TopTabsView(selectedTab: $selectedTab)
                
                // List of Novels
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.novels) { novel in
                            NovelRowView(novel: novel, selectedTab: selectedTab, deleteAction: {
                                viewModel.deleteNovel(id: novel.id) // Call delete function
                            })
                        }
                    }
                    .padding(.top, 10)
                }
                .background(Color.black)
                
                // Bottom Navigation Bar
                BottomNavBarView(selectedNavIndex: $selectedNavIndex)
            }
            .navigationBarHidden(true)
            .background(Color.black)
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Top Tabs View
struct TopTabsView: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 12) {
            TabButton(title: "Drafts", isSelected: selectedTab == 0, selectedColor: .green, defaultColor: Color("dark g"))
                .onTapGesture { selectedTab = 0 }
                .accessibilityLabel("Drafts")  // Clear label
                .accessibilityHint("Tap to view your drafts") // Additional context
                .accessibilityAddTraits(.isButton) // Explicitly mark as a button

            TabButton(title: "Collabs", isSelected: selectedTab == 1, selectedColor: .green, defaultColor: Color("dark g"))
                .onTapGesture { selectedTab = 1 }
                .accessibilityLabel("Collabs") // Clear label
                .accessibilityHint("Tap to view collaborations") // Additional context
                .accessibilityAddTraits(.isButton) // Explicitly mark as a button

            TabButton(title: "Publish", isSelected: selectedTab == 2, selectedColor: .green, defaultColor: Color("dark g"))
                .onTapGesture { selectedTab = 2 }
                .accessibilityLabel("Publish") // Clear label
                .accessibilityHint("Tap to publish content") // Additional context
                .accessibilityAddTraits(.isButton) // Explicitly mark as a button
        }
        .padding(.horizontal, 8)
        .padding(.top, 10)
    }
}


// MARK: - TabButton View
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let selectedColor: Color
    let defaultColor: Color

    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(isSelected ? .black : .white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(isSelected ? selectedColor : defaultColor)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? selectedColor : .clear, lineWidth: 2)
            )
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
                .fill(Color("dark g2"))
                .frame(width: 375.0, height: 128)
            
            HStack {
                // Book Rectangle
                Rectangle()
                    .fill(colorForName(novel.color))
                    .frame(width: 70, height: 90)
                    .cornerRadius(8)
                    .padding(.leading, 15)
//                    .padding(.leading, 70)
                    
                    .padding(.leading, selectedTab == 0 ? -25 : -25)
                    .padding(.leading, selectedTab != 2 ? 2 : -160)
                    .accessibilityLabel("Book Image")
                


                // Book Information
                VStack/*(alignment: .leading, spacing: 10)*/ {
                    
                    Text(novel.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top,-30)
                        .padding(.leading, selectedTab != 2 ? 2 : -100)
//                        .padding(.leading, selectedTab == 2 ? 2 : -100)
//                        .padding(.leading, -50)
                        .accessibilityLabel("Book Name")
                    Text(novel.date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.leading, selectedTab != 2 ? 2 : -90)
//                        .padding(.leading, -20)
                        .accessibilityLabel("Book Date")
                        
                }
                
//                Spacer()
                
                HStack  {
                    // Edit Button for Drafts and Collabs (Customized for Collabs)
                    if selectedTab == 0 || selectedTab == 1  {
                        Button(action: { }) {
                            Text("Edit")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(width: selectedTab == 1 ? 180 : 100, height: 30) // Custom size for Collabs
                                .background(Color.gray.opacity(0.8)) // Custom color for Collabs
                                .cornerRadius(8)
                                .padding(.top, 80)
                                .padding(.leading, selectedTab == 0 ? -30 : -10)
                                .accessibilityLabel("Edit")
                                .accessibilityAddTraits(.isButton)
                        }
                    }
                    
                    if selectedTab == 0 {
                        Button(action: { deleteAction() }) { // Call deleteAction on tap
                            Text("Delete")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(width: 100, height: 30)
                                .background(Color.gray.opacity(0.8))
                                .cornerRadius(8)
                                .padding(.top, 80)
                                .accessibilityLabel("Delete")
                                .accessibilityAddTraits(.isButton)
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
struct BottomNavBarView: View {
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

// MARK: - Preview
struct NovelListView_Previews: PreviewProvider {
    static var previews: some View {
        NovelListView()
    }
}
