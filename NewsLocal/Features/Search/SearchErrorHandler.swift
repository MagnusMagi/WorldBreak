//
//  SearchErrorHandler.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import SwiftUI

/// Handler for search-related errors with user-friendly messages
@MainActor
class SearchErrorHandler: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currentError: SearchError?
    @Published var showingErrorAlert = false
    @Published var errorMessage = ""
    @Published var errorAction: (() -> Void)?
    
    // MARK: - Public Methods
    
    /// Handle search error with appropriate user message
    func handleError(_ error: Error, context: SearchErrorContext = .general) {
        let searchError = SearchError.from(error, context: context)
        currentError = searchError
        errorMessage = searchError.userFriendlyMessage
        showingErrorAlert = true
        errorAction = searchError.suggestedAction
    }
    
    /// Clear current error
    func clearError() {
        currentError = nil
        showingErrorAlert = false
        errorMessage = ""
        errorAction = nil
    }
    
    /// Handle network connectivity issues
    func handleNetworkError() {
        let networkError = SearchError.networkError
        currentError = networkError
        errorMessage = networkError.userFriendlyMessage
        showingErrorAlert = true
        errorAction = {
            // Retry search action
            print("Retrying search...")
        }
    }
    
    /// Handle permission errors
    func handlePermissionError(for feature: SearchFeature) {
        let permissionError = SearchError.permissionError(feature)
        currentError = permissionError
        errorMessage = permissionError.userFriendlyMessage
        showingErrorAlert = true
        errorAction = {
            // Open settings action
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        }
    }
    
    /// Handle empty search results
    func handleEmptyResults(query: String) {
        let emptyError = SearchError.noResults(query)
        currentError = emptyError
        errorMessage = emptyError.userFriendlyMessage
        showingErrorAlert = false // Don't show alert for empty results
    }
}

// MARK: - Search Error Types

enum SearchError: LocalizedError, Identifiable {
    case networkError
    case serverError(Int)
    case noResults(String)
    case invalidQuery
    case permissionError(SearchFeature)
    case cacheError
    case voiceSearchError(String)
    case imageSearchError(String)
    case unknown(Error)
    
    var id: String {
        switch self {
        case .networkError: return "network"
        case .serverError(let code): return "server_\(code)"
        case .noResults(let query): return "no_results_\(query)"
        case .invalidQuery: return "invalid_query"
        case .permissionError(let feature): return "permission_\(feature.rawValue)"
        case .cacheError: return "cache"
        case .voiceSearchError(let message): return "voice_\(message)"
        case .imageSearchError(let message): return "image_\(message)"
        case .unknown(let error): return "unknown_\(error.localizedDescription)"
        }
    }
    
    var userFriendlyMessage: String {
        switch self {
        case .networkError:
            return "Unable to connect to the internet. Please check your connection and try again."
        case .serverError(let code):
            return "Server error (\(code)). Please try again later."
        case .noResults(let query):
            return "No results found for \"\(query)\". Try different keywords or check your spelling."
        case .invalidQuery:
            return "Please enter a valid search query."
        case .permissionError(let feature):
            return "Permission required for \(feature.displayName). Please enable it in Settings."
        case .cacheError:
            return "Cache error occurred. The app will continue to work normally."
        case .voiceSearchError(let message):
            return "Voice search error: \(message)"
        case .imageSearchError(let message):
            return "Image search error: \(message)"
        case .unknown(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    var suggestedAction: (() -> Void)? {
        switch self {
        case .networkError:
            return {
                // Retry action
                print("Retrying search...")
            }
        case .permissionError:
            return {
                // Open settings
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        case .noResults:
            return {
                // Clear search or suggest alternatives
                print("Suggesting alternative searches...")
            }
        default:
            return nil
        }
    }
    
    var errorIcon: String {
        switch self {
        case .networkError: return "wifi.exclamationmark"
        case .serverError: return "server.rack"
        case .noResults: return "magnifyingglass"
        case .invalidQuery: return "questionmark.circle"
        case .permissionError: return "lock.circle"
        case .cacheError: return "externaldrive.exclamationmark"
        case .voiceSearchError: return "mic.slash"
        case .imageSearchError: return "camera.badge.exclamationmark"
        case .unknown: return "exclamationmark.triangle"
        }
    }
    
    var errorColor: Color {
        switch self {
        case .networkError: return DesignSystem.Colors.warning
        case .serverError: return DesignSystem.Colors.error
        case .noResults: return DesignSystem.Colors.info
        case .invalidQuery: return DesignSystem.Colors.secondary
        case .permissionError: return DesignSystem.Colors.error
        case .cacheError: return DesignSystem.Colors.warning
        case .voiceSearchError: return DesignSystem.Colors.error
        case .imageSearchError: return DesignSystem.Colors.error
        case .unknown: return DesignSystem.Colors.error
        }
    }
    
    /// Create SearchError from generic Error
    static func from(_ error: Error, context: SearchErrorContext) -> SearchError {
        if let appError = error as? AppError {
            switch appError {
            case .network(let networkError):
                switch networkError {
                case .noInternet, .networkUnavailable:
                    return .networkError
                case .timeout, .requestTimeout:
                    return .networkError
                case .serverError(let code):
                    return .serverError(code)
                case .invalidResponse:
                    return .serverError(500)
                case .decodingError:
                    return .serverError(500)
                default:
                    return .networkError
                }
            case .validation, .storage, .authenticationFailed, .notAuthenticated, .unknown:
                return .unknown(error)
            }
        }
        
        return .unknown(error)
    }
}

// MARK: - Supporting Types

enum SearchFeature: String, CaseIterable {
    case microphone = "microphone"
    case camera = "camera"
    case speechRecognition = "speech_recognition"
    case photoLibrary = "photo_library"
    
    var displayName: String {
        switch self {
        case .microphone: return "Microphone"
        case .camera: return "Camera"
        case .speechRecognition: return "Speech Recognition"
        case .photoLibrary: return "Photo Library"
        }
    }
}

enum SearchErrorContext {
    case general
    case search
    case suggestions
    case trending
    case voice
    case image
    case cache
}

// MARK: - Error Alert View

struct SearchErrorAlert: View {
    let error: SearchError
    let onDismiss: () -> Void
    let onAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: error.errorIcon)
                .font(.system(size: 48))
                .foregroundColor(error.errorColor)
            
            Text(error.userFriendlyMessage)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignSystem.Spacing.md)
            
            HStack(spacing: DesignSystem.Spacing.md) {
                Button("OK") {
                    onDismiss()
                }
                .secondaryButtonStyle()
                
                if let action = onAction {
                    Button("Retry") {
                        action()
                        onDismiss()
                    }
                    .primaryButtonStyle()
                }
            }
        }
        .padding(DesignSystem.Spacing.xl)
    }
}

// MARK: - Extensions

extension SearchErrorHandler {
    /// Mock data for previews
    static let mock = SearchErrorHandler()
}
