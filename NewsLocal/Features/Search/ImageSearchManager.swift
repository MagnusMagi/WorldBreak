//
//  ImageSearchManager.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import UIKit
import Vision

/// Manager for handling image search functionality
@MainActor
class ImageSearchManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isProcessing = false
    @Published var detectedText = ""
    
    // MARK: - Private Properties
    
    private let textRecognitionQueue = DispatchQueue(label: "textRecognition", qos: .userInitiated)
    
    // MARK: - Public Methods
    
    /// Extract text from image using Vision framework
    func extractText(from image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        isProcessing = true
        
        textRecognitionQueue.async {
            guard let cgImage = image.cgImage else {
                DispatchQueue.main.async {
                    self.isProcessing = false
                    completion(.failure(ImageSearchError.invalidImage))
                }
                return
            }
            
            let request = VNRecognizeTextRequest { request, error in
                DispatchQueue.main.async {
                    self.isProcessing = false
                    
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let observations = request.results as? [VNRecognizedTextObservation] else {
                        completion(.failure(ImageSearchError.noTextFound))
                        return
                    }
                    
                    let recognizedText = observations.compactMap { observation in
                        observation.topCandidates(1).first?.string
                    }.joined(separator: " ")
                    
                    if recognizedText.isEmpty {
                        completion(.failure(ImageSearchError.noTextFound))
                    } else {
                        completion(.success(recognizedText))
                    }
                }
            }
            
            // Configure text recognition
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en"]
            request.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.isProcessing = false
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Extract text from image with custom configuration
    func extractText(
        from image: UIImage,
        recognitionLevel: VNRequestTextRecognitionLevel = .accurate,
        languages: [String] = ["en"],
        usesLanguageCorrection: Bool = true,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        isProcessing = true
        
        textRecognitionQueue.async {
            guard let cgImage = image.cgImage else {
                DispatchQueue.main.async {
                    self.isProcessing = false
                    completion(.failure(ImageSearchError.invalidImage))
                }
                return
            }
            
            let request = VNRecognizeTextRequest { request, error in
                DispatchQueue.main.async {
                    self.isProcessing = false
                    
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let observations = request.results as? [VNRecognizedTextObservation] else {
                        completion(.failure(ImageSearchError.noTextFound))
                        return
                    }
                    
                    let recognizedText = observations.compactMap { observation in
                        observation.topCandidates(1).first?.string
                    }.joined(separator: " ")
                    
                    if recognizedText.isEmpty {
                        completion(.failure(ImageSearchError.noTextFound))
                    } else {
                        completion(.success(recognizedText))
                    }
                }
            }
            
            // Configure text recognition
            request.recognitionLevel = recognitionLevel
            request.recognitionLanguages = languages
            request.usesLanguageCorrection = usesLanguageCorrection
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.isProcessing = false
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Process image for news-related content
    func processImageForNews(from image: UIImage, completion: @escaping (Result<NewsImageAnalysis, Error>) -> Void) {
        extractText(from: image) { result in
            switch result {
            case .success(let text):
                let analysis = NewsImageAnalysis(
                    extractedText: text,
                    keywords: self.extractKeywords(from: text),
                    suggestedQueries: self.generateSearchQueries(from: text)
                )
                completion(.success(analysis))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Extract keywords from text
    private func extractKeywords(from text: String) -> [String] {
        let words = text.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty && $0.count > 3 }
        
        // Remove common words
        let commonWords = Set(["this", "that", "with", "have", "will", "from", "they", "been", "were", "said", "each", "which", "their", "time", "would", "there", "could", "other"])
        
        let filteredWords = words.filter { !commonWords.contains($0) }
        
        // Count word frequency
        let wordCounts = Dictionary(grouping: filteredWords, by: { $0 })
            .mapValues { $0.count }
        
        // Return top keywords
        return Array(wordCounts.sorted { $0.value > $1.value }.prefix(5).map { $0.key })
    }
    
    /// Generate search queries from text
    private func generateSearchQueries(from text: String) -> [String] {
        let keywords = extractKeywords(from: text)
        var queries: [String] = []
        
        // Add individual keywords
        queries.append(contentsOf: keywords)
        
        // Add keyword combinations
        if keywords.count >= 2 {
            for i in 0..<keywords.count-1 {
                queries.append("\(keywords[i]) \(keywords[i+1])")
            }
        }
        
        // Add full text as query
        if text.count > 10 && text.count < 100 {
            queries.append(text)
        }
        
        return Array(Set(queries)).prefix(5).map { $0 }
    }
}

// MARK: - Supporting Models

/// Analysis result for news-related images
struct NewsImageAnalysis: Codable {
    let extractedText: String
    let keywords: [String]
    let suggestedQueries: [String]
    
    /// Get the best search query
    var bestQuery: String {
        if !suggestedQueries.isEmpty {
            return suggestedQueries.first ?? extractedText
        }
        return extractedText
    }
}

// MARK: - Image Search Error

enum ImageSearchError: LocalizedError {
    case invalidImage
    case noTextFound
    case processingFailed
    case permissionDenied
    
    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Invalid image provided"
        case .noTextFound:
            return "No text found in the image"
        case .processingFailed:
            return "Failed to process the image"
        case .permissionDenied:
            return "Camera or photo library permission denied"
        }
    }
}

// MARK: - Extensions

extension ImageSearchManager {
    /// Mock data for previews
    static let mock = ImageSearchManager()
}
