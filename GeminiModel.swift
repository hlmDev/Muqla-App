//
//  GeminiModel.swift
//  muqlla
//
//  Created by Ahlam Majed on 26/12/2024.
//

import Foundation
import GoogleGenerativeAI // Assuming this is the correct SDK

class GenerativeAI {
    private let apiKey: String

    // Initialize GeminiModel with API Key
    init(apiKey: String) {
        self.apiKey = "AIzaSyCzbBYn28ONyBrTLlW7L579HMoN2oC4n84"
    }

    // Function to improve writing using AI
    func improveWriting(text: String, completion: @escaping (Result<String, Error>) -> Void) {
        generateTextForPrompt(prompt: "Improve the following text: \(text)", completion: completion)
    }

    // Function to check grammar using AI
    func checkGrammar(text: String, completion: @escaping (Result<String, Error>) -> Void) {
        generateTextForPrompt(prompt: "Correct the grammar of the following text: \(text)", completion: completion)
    }

    // Function to translate meaning using AI
    func translateMeaning(text: String, completion: @escaping (Result<String, Error>) -> Void) {
        generateTextForPrompt(prompt: "Translate the meaning of the following text: \(text)", completion: completion)
    }

    // General function to generate text based on any prompt
    private func generateTextForPrompt(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Assuming the generative model is set up properly in the SDK
        let model = GenerativeModel(name: "gemini-pro", apiKey: self.apiKey)

        Task {
            do {
                let response = try await model.generateContent(prompt)
                if let text = response.text {
                    completion(.success(text)) // Return generated text
                } else {
                    completion(.success("Empty response"))
                }
            } catch {
                completion(.failure(error)) // Handle error
            }
        }
    }
}
