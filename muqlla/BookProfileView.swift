//
//  BookProfileView.swift
//  muqlla
//
//  Created by Alshaimaa on 23/06/1446 AH.
//
import SwiftUI
struct BookProfileView: View {
var body: some View {
NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    // العنوان العلوي
                    HStack {
                        Button(action: {
                            // الإجراء عند الضغط على زر الرجوع
                            print("Back button tapped!")
                        }) {
                            Text("Back")
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.black)
                    // صورة الكتاب والعنوان
                    VStack {
                        Rectangle() 
                            .fill(Color.bookcolor)
                            .frame(width: 200, height: 300)
                            .overlay(
                                VStack {
                                    Spacer().frame(height: 40) // مسافة فارغة صغيرة بين النصوص
                                    Text("Wish I Were My Alter Ego")
                                        .font(.title2)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                    Spacer().frame(height: 30) // مسافة فارغة صغيرة بين النصوص
                                    Text("by")
                                        .foregroundColor(.white)
                                    Spacer().frame(height: 20) // مسافة فارغة صغيرة بين النصوص
                                    Text("Alanoud Alsamil")
                                        .bold()
                                        .foregroundColor(.white)
                                    Spacer() // يدفع باقي المحتوى إلى الأسفل
                                    
                                    HStack {
                                        Text("Incomplete")
                                            .foregroundColor(.white)
                                            .padding(.leading) // مسافة على اليسار
                                        Spacer() // يدفع النص إلى الزاوية اليسرى
                                    }
                                }
                                .padding() // مسافة داخلية لتجنب الالتصاق بالحواف
                            )
                    }  .padding(.top)
                    
                    // تفاصيل الكتاب
                    VStack(alignment: .leading, spacing: 8) {
                        // استخدام InfoRow
                        InfoRow(label:NSLocalizedString( "Author:", comment: ""),
                                value: NSLocalizedString("Alanoud Alsamil", comment: ""))
                        InfoRow(label:NSLocalizedString("Co-authors:", comment: ""),
                                value: NSLocalizedString("Reem, Shahad, Ahlam", comment: ""))
                    }
                    .padding(.top)

                    // Add a separator between the two sections
                    Divider()

                    HStack {
                        Text("★★★☆☆")
                        Text("10.7K Readers")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                    // زر "Start Reading" للتنقل إلى صفحة المحتوى
                    NavigationLink(destination: BookContentView()) {
                        
                        Text("Start Reading")
                            .bold()
                            .font(.system(size: 20)) // Adjust font size if needed
                            .padding(.vertical, 15)  // Keep the vertical padding for height
                            .padding(.horizontal, 115)  // Reduce horizontal padding to make the button narrower
                            .background(Color.btncolor) // Your desired background color
                            .foregroundColor(.white)
                            .cornerRadius(25)

                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // زر "Start a new chapter"
                    BookActionButton()
                        .padding(.bottom, 2)
                        .padding(.horizontal)
                    
                    // تفاصيل إضافية
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 32) {
                            DetailColumnView(title:NSLocalizedString( "PAGES", comment: ""), value:NSLocalizedString("644", comment: ""))
                            DetailColumnView(title:NSLocalizedString(  "PARTS", comment: ""),value: NSLocalizedString("5", comment: ""))
                            DetailColumnView(title:NSLocalizedString(  "LANGUAGE", comment: ""), value: NSLocalizedString("English", comment: ""))
                            DetailColumnView(title:NSLocalizedString(   "CATEGORY", comment: ""), value: NSLocalizedString("Pycology", comment: ""))
                            DetailColumnView(title:NSLocalizedString(   "RELEASED", comment: ""),value: NSLocalizedString("2025/1/1", comment: ""))
                        }
                        .padding()
                    }
                    .background(Color.black)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    
                    // وصف الكتاب
                    VStack(alignment: .leading) {
                        Text("Book Description")
                            .font(.headline)
                        Text("""
                             Explore the legacy of Alfred Marshall, a pioneer of the neoclassical school of economics.
                             This book highlights his groundbreaking ideas on utility, supply, and demand, as well as his efforts to make economics accessible. Marshall’s work shaped modern economic thought, emphasizing individual behavior and its influence on production, costs, and market value. A must-read for understanding the foundations of contemporary economics.
                             """)
                        .font(.body)
                        .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .navigationBarHidden(true) // إخفاء شريط التنقل العلوي
        }
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
    var body: some View {
        Button(action: {
            // قم بإضافة الأكشن هنا
            print("Start new chapter tapped!")
        }) {
            Text("Start New Chapter")
                .font(.system(size: 20)) // Adjust font size to match "Start Reading"
                .bold()
                .padding(.vertical, 15)   // Adjust vertical padding for height
                .padding(.horizontal, 100)  // Adjust horizontal padding to match "Start Reading" width
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray, lineWidth: 1.5) // Border with desired thickness
                )
                .foregroundColor(.white)  // Text color (not transparent)
                .cornerRadius(25)  // Keep the same rounded corners

        }
        .padding(.bottom, 20)
    }
}

struct InfoRow: View {
    let label: String // النص الأول (العنوان)
    let value: String // النص الثاني (القيمة)
    
    var body: some View {
        HStack(spacing: 16) {
            Text(label)
                .font(.headline)
                .foregroundColor(.gray) // لون النص الأول
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white) // لون النص الثاني
        }
        .padding(.horizontal)
    }
}

struct BookProfileView_Previews: PreviewProvider {
    static var previews: some View {
        BookProfileView()
    }
}

