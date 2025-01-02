import SwiftUI
//
//struct BookProfileView: View {
//    @State private var navigateToHome = false
//
//    var body: some View {
//        NavigationView {
//            ScrollView(.vertical, showsIndicators: true) {
//                VStack {
//                    // Top Header with Back Button
//                   // Book Image and Title Section
//                    VStack {
//                        Rectangle()
//                            .fill(Color.bookcolor) // Ensure Color.bookcolor is defined
//                            .frame(width: 200, height: 300)
//                            .overlay(
//                                VStack {
//                                    Spacer().frame(height: 40)
//                                    Text("Wish I Were My Alter Ego")
//                                        .font(.title2)
//                                        .bold()
//                                        .multilineTextAlignment(.center)
//                                        .foregroundColor(.white)
//                                    Spacer().frame(height: 30)
//                                    Text("by")
//                                        .foregroundColor(.white)
//                                    Spacer().frame(height: 20)
//                                    Text("Alanoud Alsamil")
//                                        .bold()
//                                        .foregroundColor(.white)
//                                    Spacer()
//
//                                    HStack {
//                                        Text("Incomplete")
//                                            .foregroundColor(.white)
//                                            .padding(.leading)
//                                        Spacer()
//                                    }
//                                }
//                                .padding()
//                            )
//                    }
//                    .padding(.top)
//
//                    // Book Details Section
//                    VStack(alignment: .leading, spacing: 8) {
//                        InfoRow(label: NSLocalizedString("Author:", comment: ""), value: NSLocalizedString("Alanoud Alsamil", comment: ""))
//                        InfoRow(label: NSLocalizedString("Co-authors:", comment: ""), value: NSLocalizedString("Reem, Shahad, Ahlam", comment: ""))
//                    }
//                    .padding(.top)
//
//                    Divider()
//
//                    // Ratings and Reader Count Section
//                    HStack {
//                        Text("★★★☆☆")
//                        Text("10.7K Readers")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .multilineTextAlignment(.center)
//                    .padding(.bottom)
//
//                    // Start Reading Button
//                    NavigationLink(destination: BookContentView()) {
//
//                        Text("Start Reading")
//                            .bold()
//                            .font(.system(size: 20))
//                            .padding(.vertical, 15)
//                            .padding(.horizontal, 115)
//                            .background(Color.btncolor) // Ensure Color.btncolor is defined
//                            .foregroundColor(.white)
//                            .cornerRadius(25)
//                    }
//                    .padding(.horizontal)
//
//                    Spacer()
//
//                    // Start New Chapter Button
//                    BookActionButton()
//                        .padding(.bottom, 2)
//                        .padding(.horizontal)
//
//                    // Additional Book Details Section (Horizontal Scroll)
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 32) {
//                            DetailColumnView(title: NSLocalizedString("PAGES", comment: ""), value: NSLocalizedString("644", comment: ""))
//                            DetailColumnView(title: NSLocalizedString("PARTS", comment: ""), value: NSLocalizedString("5", comment: ""))
//                            DetailColumnView(title: NSLocalizedString("LANGUAGE", comment: ""), value: NSLocalizedString("English", comment: ""))
//                            DetailColumnView(title: NSLocalizedString("CATEGORY", comment: ""), value: NSLocalizedString("Psychology", comment: ""))
//                            DetailColumnView(title: NSLocalizedString("RELEASED", comment: ""), value: NSLocalizedString("2025/1/1", comment: ""))
//                        }
//                        .padding()
//                    }
//                    .background(Color.black)
//                    .foregroundColor(.white)
//                    .padding(.bottom, 20)
//
//                    // Book Description Section
//                    VStack(alignment: .leading) {
//                        Text("Book Description")
//                            .font(.headline)
//                        ScrollView {
//                            Text("""
//                            Explore the legacy of Alfred Marshall, a pioneer of the neoclassical school of economics.
//                            This book highlights his groundbreaking ideas on utility, supply, and demand, as well as his efforts to make economics accessible. Marshall’s work shaped modern economic thought, emphasizing individual behavior and its influence on production, costs, and market value. A must-read for understanding the foundations of contemporary economics.
//                            """)
//                            .font(.body)
//                            .foregroundColor(.gray)
//                        }
//                    }
//                    .padding(.horizontal)
//
//                    Spacer()
//                }
//            }
//            .background(Color.black.edgesIgnoringSafeArea(.all))
//            .foregroundColor(.white)
//            .navigationBarHidden(true)
//        }
//    }
//}
//
//// Define the DetailColumnView used for additional info
//struct DetailColumnView: View {
//    let title: String
//    let value: String
//
//    var body: some View {
//        VStack {
//            Text(title)
//                .font(.caption)
//                .foregroundColor(.gray)
//            Text(value)
//                .font(.headline)
//                .multilineTextAlignment(.center)
//        }
//        .frame(maxWidth: .infinity)
//    }
//}
//
//// Button to Start a New Chapter
////struct BookActionButton: View {
////    var body: some View {
////        Button(action: {
////            // Add action for starting a new chapter
////            print("Start new chapter tapped!")
////        }) {
////            Text("Start New Chapter")
////                .font(.system(size: 20))
////                .bold()
////                .padding(.vertical, 15)
////                .padding(.horizontal, 100)
////                .background(
////                    RoundedRectangle(cornerRadius: 25)
////                        .stroke(Color.gray, lineWidth: 1.5) // Border with desired thickness
////                )
////                .foregroundColor(.white)
////                .cornerRadius(25)
////        }
////        .padding(.bottom, 20)
////    }
////}
//
//struct BookActionButton: View {
//    @State private var showWriteBookView = false // State to control navigation
//
//    var body: some View {
//        Button(action: {
//            showWriteBookView = true
//        }) {
//            Text("Start New Chapter")
//                .font(.system(size: 20))
//                .bold()
//                .padding(.vertical, 15)
//                .padding(.horizontal, 100)
//                .background(
//                    RoundedRectangle(cornerRadius: 25)
//                        .stroke(Color.gray, lineWidth: 1.5)
//                )
//                .foregroundColor(.white)
//                .cornerRadius(25)
//        }
//        .padding(.bottom, 20)
//        .sheet(isPresented: $showWriteBookView) {
//            NavigationView {
//                WriteBookView()
//            }
//        }
//    }
//}
//// InfoRow used for book details (Author, Co-authors, etc.)
//struct InfoRow: View {
//    let label: String
//    let value: String
//
//    var body: some View {
//        HStack(spacing: 16) {
//            Text(label)
//                .font(.headline)
//                .foregroundColor(.gray)
//            Text(value)
//                .font(.subheadline)
//                .foregroundColor(.white)
//        }
//        .padding(.horizontal)
//    }
//}
//
//struct BookProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookProfileView()
//    }
//}

import SwiftUI

// Supporting Views
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text(label)
                .font(.headline)
                .foregroundColor(.gray)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding(.horizontal)
    }
}

struct DetailColumnView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct BookActionButton: View {
    @State private var showWriteBookView = false
    
    var body: some View {
        Button(action: {
            showWriteBookView = true
        }) {
            Text("Start New Chapter")
                .font(.system(size: 20))
                .bold()
                .padding(.vertical, 15)
                .padding(.horizontal, 100)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray, lineWidth: 1.5)
                )
                .foregroundColor(.white)
                .cornerRadius(25)
        }
        .padding(.bottom, 20)
        .sheet(isPresented: $showWriteBookView) {
            NavigationView {
                WriteBookView()
            }
        }
    }
}

// Main BookProfileView
struct BookProfileView: View {
    @Environment(\.dismiss) var dismiss
    let book: Book
    @StateObject private var bookVM = BookViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                // Back Button
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.green)
                    }
                    Spacer()
                }
                .padding()
                
                // Book Cover and Title Section
                VStack {
                    Rectangle()
                        .fill(book.displayColor)
                        .frame(width: 200, height: 300)
                        .overlay(
                            VStack {
                                Spacer().frame(height: 40)
                                Text(book.title)
                                    .font(.title2)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                Spacer().frame(height: 30)
                                Text("by")
                                    .foregroundColor(.white)
                                Spacer().frame(height: 20)
                                Text(book.author)
                                    .bold()
                                    .foregroundColor(.white)
                                Spacer()
                                
                                HStack {
                                    Text(book.status)
                                        .foregroundColor(.white)
                                        .padding(.leading)
                                    Spacer()
                                }
                            }
                            .padding()
                        )
                }
                .padding(.top)
                
                // Book Details Section
                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(label: "Author:", value: book.author)
                    if book.isCollaborative {
                        InfoRow(label: "Co-authors:", value: "Reem, Shahad, Ahlam")
                    }
                }
                .padding(.top)
                
                Divider()
                
                // Ratings Section
                HStack {
                    Text("★★★☆☆")
                    Text("10.7K Readers")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.bottom)
                
                // Action Buttons
                NavigationLink(destination: BookContentView(book: book)) {
                    Text("Start Reading")
                        .bold()
                        .font(.system(size: 20))
                        .padding(.vertical, 15)
                        .padding(.horizontal, 115)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                .padding(.horizontal)
                
                BookActionButton()
                    .padding(.bottom, 2)
                    .padding(.horizontal)
                
                // Book Details
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 32) {
                        DetailColumnView(title: "PAGES", value: "644")
                        DetailColumnView(title: "PARTS", value: "5")
                        DetailColumnView(title: "LANGUAGE", value: "English")
                        DetailColumnView(title: "CATEGORY", value: "Psychology")
                        DetailColumnView(title: "RELEASED", value: "2025/1/1")
                    }
                    .padding()
                }
                .background(Color.black)
                .foregroundColor(.white)
                .padding(.bottom, 20)
                
                // Description Section
                VStack(alignment: .leading) {
                    Text("Book Description")
                        .font(.headline)
                    ScrollView {
                        Text(book.description ?? "No description available.")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
        .navigationBarHidden(true)
    }
}
