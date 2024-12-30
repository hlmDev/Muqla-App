import SwiftUI
import GoogleGenerativeAI
import CloudKit
import PhotosUI

struct WriteBookView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var collaboratorsCount = 1
    @State private var showCancelDialog = false
    @State private var showWritingSheet = false
    @State private var bookContent = ""
    @State private var aiAction = ""
    @State private var showAIOptions = false
    @State private var aiResult = ""
    @StateObject private var cloudKitVM = CloudKitUserViewModel()
    @StateObject private var bookVM = BookViewModel()
    @State private var generativeAI: GenerativeAI?
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?

    // MARK: - CloudKit Functions
    
    
    func saveBook() {
        let container = CKContainer(identifier: "iCloud.com.a.muqlla")
        let record = CKRecord(recordType: "Book")
       
        let authorRecordID = CKRecord.ID(recordName: cloudKitVM.authorName)
        let authorReference = CKRecord.Reference(recordID: authorRecordID, action: .none)
       
        record["author"] = authorReference
        record["title"] = title
        record["content"] = bookContent  // Make sure to save the content
        record["description"] = description
        record["createdAt"] = Date()
        record["status"] = "Published"
        record["isDraft"] = 0
        record["collaborators"] = [authorReference]
        record["collaboratorsCount"] = collaboratorsCount

        // Add cover image if available
        if let imageData = selectedImageData {
            let asset = CKAsset(fileURL: saveImageTemporarily(imageData))
            record["coverImage"] = asset
        }
       
        container.publicCloudDatabase.save(record) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Failed to save: \(error.localizedDescription)"
                    showError = true
                    return
                }
                print("Book saved successfully")
                dismiss()
            }
        }
    }
    
//    func saveBook() {
//        let container = CKContainer(identifier: "iCloud.com.a.muqlla")
//        let record = CKRecord(recordType: "Book")
//   
//        let authorRecordID = CKRecord.ID(recordName: cloudKitVM.authorName)
//        let authorReference = CKRecord.Reference(recordID: authorRecordID, action: .none)
//   
//        record["author"] = authorReference
//        record["title"] = title
//        record["content"] = bookContent
//        record["description"] = description
//        record["createdAt"] = Date()
//        record["status"] = "Published"
//        record["isDraft"] = 0
//        record["collaborators"] = [authorReference]
//        record["collaboratorsCount"] = collaboratorsCount
//
//        // Add cover image if available
//        if let imageData = selectedImageData {
//            let asset = CKAsset(fileURL: saveImageTemporarily(imageData))
//            record["coverImage"] = asset
//        }
//   
//        container.publicCloudDatabase.save(record) { record, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    errorMessage = "Failed to save: \(error.localizedDescription)"
//                    showError = true
//                    return
//                }
//                print("Book saved successfully")
//                dismiss()
//            }
//        }
//    }
    
    func saveToDraft() {
        let container = CKContainer(identifier: "iCloud.com.a.muqlla")
        let record = CKRecord(recordType: "Book")
   
        let authorRecordID = CKRecord.ID(recordName: cloudKitVM.authorName)
        let authorReference = CKRecord.Reference(recordID: authorRecordID, action: .none)
   
        record["author"] = authorReference
        record["title"] = title
        record["content"] = bookContent
        record["description"] = description
        record["createdAt"] = Date()
        record["status"] = "Draft"
        record["isDraft"] = 1
        record["collaborators"] = [authorReference]
        record["collaboratorsCount"] = collaboratorsCount

        // Add cover image if available
        if let imageData = selectedImageData {
            let asset = CKAsset(fileURL: saveImageTemporarily(imageData))
            record["coverImage"] = asset
        }
   
        container.publicCloudDatabase.save(record) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Failed to save draft: \(error.localizedDescription)"
                    showError = true
                    return
                }
                dismiss()
            }
        }
    }

    private func saveImageTemporarily(_ imageData: Data) -> URL {
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = temporaryDirectory.appendingPathComponent(fileName)
        
        try? imageData.write(to: fileURL)
        return fileURL
    }

    // MARK: - AI Functions
    
    private func initializeGeminiModel() {
        let apiKey = "AIzaSyCzbBYn28ONyBrTLlW7L579HMoN2oC4n84"
        generativeAI = GenerativeAI(apiKey: apiKey)
    }

    private func performAIAction() {
        guard let ai = generativeAI else {
            aiResult = "AI Model not initialized"
            return
        }

        switch aiAction {
        case "improveWriting":
            ai.improveWriting(text: bookContent) { result in
                handleAIResponse(result: result)
            }
        case "checkGrammar":
            ai.checkGrammar(text: bookContent) { result in
                handleAIResponse(result: result)
            }
        case "translateMeaning":
            ai.translateMeaning(text: bookContent) { result in
                handleAIResponse(result: result)
            }
        default:
            aiResult = "Unknown action"
        }
    }

    private func handleAIResponse(result: Result<String, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let response):
                aiResult = response
                bookContent = response
            case .failure(let error):
                errorMessage = "AI Error: \(error.localizedDescription)"
                showError = true
            }
        }
    }

    // MARK: - View Body
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    bookCoverSection
                    collaboratorsSection
                    descriptionSection
                    startWritingButton
                }
                .padding(.top)
            }
        }
        .sheet(isPresented: $showWritingSheet) {
            writingSheetView
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .confirmationDialog("Select Action", isPresented: $showCancelDialog) {
            Button("Save to Draft", role: .none) {
                saveToDraft()
            }
            Button("Delete", role: .destructive) {
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    showCancelDialog = true
                }
                .foregroundColor(.white)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Publish") {
                    if !title.isEmpty {
                        saveBook()
                    }
                }
                .foregroundColor(title.isEmpty ? .gray : .white)
                .disabled(title.isEmpty)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            initializeGeminiModel()
        }
    }
    
    // MARK: - View Components
    
    private var bookCoverSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Book Cover")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.top, 16)
            
            HStack(spacing: 16) {
                PhotosPicker(selection: $selectedItem,
                           matching: .images,
                           photoLibrary: .shared()) {
                    if let selectedImageData,
                       let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 180)
                            .cornerRadius(8)
                            .padding(10)
                    } else {
                        Color.gray.opacity(0.2)
                            .frame(width: 120, height: 180)
                            .cornerRadius(8)
                            .padding(10)
                            .overlay(
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            )
                    }
                }
                .onChange(of: selectedItem) { item in
                    Task {
                        if let data = try? await item?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Book Title")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    TextField("Enter your book title", text: $title)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    private var collaboratorsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Number of Collaborators")
                .foregroundColor(.white)
                .font(.headline)
            
            Stepper(value: $collaboratorsCount, in: 1...5) {
                Text("\(collaboratorsCount) Collaborator(s)")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Book Description")
                .foregroundColor(.white)
                .font(.headline)
            
            ZStack(alignment: .topLeading) {
                if description.isEmpty {
                    Text("Start writing your book description...")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $description)
                    .foregroundColor(.white)
                    .frame(height: 150)
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }
    
    private var startWritingButton: some View {
        Button(action: {
            showWritingSheet.toggle()
        }) {
            Text("Start Writing Your Book")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.vertical, 30)
    }
    
    private var writingSheetView: some View {
        NavigationView {
            VStack(spacing: 24) {
                TextEditor(text: $bookContent)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)

                Button(action: {
                    showAIOptions.toggle()
                }) {
                    Image(systemName: "wand.and.stars")
                        .foregroundColor(.blue)
                        .font(.title)
                }
            }
            .padding(.top)
            .navigationTitle("Write Your Content")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showWritingSheet = false
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        showWritingSheet = false
                    }
                    .foregroundColor(.blue)
                }
            }
            .actionSheet(isPresented: $showAIOptions) {
                ActionSheet(title: Text("Select AI Function"), buttons: [
                    .default(Text("Improve Writing")) {
                        aiAction = "improveWriting"
                        performAIAction()
                    },
                    .default(Text("Check Grammar")) {
                        aiAction = "checkGrammar"
                        performAIAction()
                    },
                    .default(Text("Translate Meaning")) {
                        aiAction = "translateMeaning"
                        performAIAction()
                    },
                    .cancel()
                ])
            }
        }
    }
}

// MARK: - Preview Provider

struct WriteBookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WriteBookView()
        }
        .preferredColorScheme(.dark)
    }
}
