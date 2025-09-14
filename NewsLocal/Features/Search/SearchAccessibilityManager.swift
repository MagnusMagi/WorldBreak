//
//  SearchAccessibilityManager.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import SwiftUI

/// Manager for handling accessibility features in search functionality
@MainActor
class SearchAccessibilityManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isVoiceOverEnabled = false
    @Published var isReduceMotionEnabled = false
    @Published var isReduceTransparencyEnabled = false
    @Published var preferredContentSizeCategory: ContentSizeCategory = .medium
    
    // MARK: - Private Properties
    
    private var accessibilityObservers: [NSObjectProtocol] = []
    
    // MARK: - Initialization
    
    init() {
        setupAccessibilityObservers()
        updateAccessibilitySettings()
    }
    
    deinit {
        removeAccessibilityObservers()
    }
    
    // MARK: - Public Methods
    
    /// Get accessibility-friendly search suggestions
    func getAccessibleSearchSuggestions(_ suggestions: [String]) -> [String] {
        // Limit suggestions for VoiceOver users to avoid overwhelming
        if isVoiceOverEnabled {
            return Array(suggestions.prefix(3))
        }
        return suggestions
    }
    
    /// Get accessibility-friendly search results
    func getAccessibleSearchResults(_ results: [NewsArticle]) -> [NewsArticle] {
        // For VoiceOver users, we might want to limit results or provide additional context
        return results
    }
    
    /// Generate accessibility label for search result
    func generateSearchResultLabel(_ article: NewsArticle, index: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        let dateString = dateFormatter.string(from: article.publishedAt)
        
        return """
        Article \(index + 1) of \(article.title). 
        Published on \(dateString). 
        Source: \(article.source.name). 
        Category: \(article.category.displayName). 
        Reading time: \(article.readingTime) minutes.
        """
    }
    
    /// Generate accessibility hint for search actions
    func generateSearchActionHint(for action: SearchAction) -> String {
        switch action {
        case .search:
            return "Double tap to perform search"
        case .voiceSearch:
            return "Double tap to start voice search"
        case .imageSearch:
            return "Double tap to open image search"
        case .filter:
            return "Double tap to open filters"
        case .clearSearch:
            return "Double tap to clear search text"
        case .loadMore:
            return "Double tap to load more results"
        case .suggestion:
            return "Double tap to search for this suggestion"
        case .favorite:
            return "Double tap to toggle favorite"
        case .share:
            return "Double tap to share article"
        }
    }
    
    /// Get appropriate animation duration based on accessibility settings
    func getAnimationDuration() -> Double {
        return isReduceMotionEnabled ? 0.0 : DesignSystem.Animation.quick
    }
    
    /// Get appropriate corner radius based on accessibility settings
    func getCornerRadius(_ baseRadius: CGFloat) -> CGFloat {
        // Reduce corner radius for better accessibility
        return isReduceMotionEnabled ? baseRadius * 0.5 : baseRadius
    }
    
    /// Check if user prefers reduced motion
    func shouldReduceMotion() -> Bool {
        return isReduceMotionEnabled
    }
    
    /// Check if user prefers reduced transparency
    func shouldReduceTransparency() -> Bool {
        return isReduceTransparencyEnabled
    }
    
    /// Get appropriate font size for current content size category
    func getFontSize(for style: FontStyle) -> Font {
        let baseFont = style.baseFont
        
        switch preferredContentSizeCategory {
        case .extraSmall:
            return baseFont.size(style.sizes.extraSmall)
        case .small:
            return baseFont.size(style.sizes.small)
        case .medium:
            return baseFont.size(style.sizes.medium)
        case .large:
            return baseFont.size(style.sizes.large)
        case .extraLarge:
            return baseFont.size(style.sizes.extraLarge)
        case .extraExtraLarge:
            return baseFont.size(style.sizes.extraExtraLarge)
        case .extraExtraExtraLarge:
            return baseFont.size(style.sizes.extraExtraExtraLarge)
        case .accessibilityMedium:
            return baseFont.size(style.sizes.accessibilityMedium)
        case .accessibilityLarge:
            return baseFont.size(style.sizes.accessibilityLarge)
        case .accessibilityExtraLarge:
            return baseFont.size(style.sizes.accessibilityExtraLarge)
        case .accessibilityExtraExtraLarge:
            return baseFont.size(style.sizes.accessibilityExtraExtraLarge)
        case .accessibilityExtraExtraExtraLarge:
            return baseFont.size(style.sizes.accessibilityExtraExtraExtraLarge)
        @unknown default:
            return baseFont.size(style.sizes.medium)
        }
    }
    
    // MARK: - Private Methods
    
    /// Setup accessibility observers
    private func setupAccessibilityObservers() {
        let voiceOverObserver = NotificationCenter.default.addObserver(
            forName: UIAccessibility.voiceOverStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAccessibilitySettings()
        }
        
        let reduceMotionObserver = NotificationCenter.default.addObserver(
            forName: UIAccessibility.reduceMotionStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAccessibilitySettings()
        }
        
        let reduceTransparencyObserver = NotificationCenter.default.addObserver(
            forName: UIAccessibility.reduceTransparencyStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAccessibilitySettings()
        }
        
        accessibilityObservers = [voiceOverObserver, reduceMotionObserver, reduceTransparencyObserver]
    }
    
    /// Remove accessibility observers
    private func removeAccessibilityObservers() {
        accessibilityObservers.forEach { NotificationCenter.default.removeObserver($0) }
        accessibilityObservers.removeAll()
    }
    
    /// Update accessibility settings
    private func updateAccessibilitySettings() {
        isVoiceOverEnabled = UIAccessibility.isVoiceOverRunning
        isReduceMotionEnabled = UIAccessibility.isReduceMotionEnabled
        isReduceTransparencyEnabled = UIAccessibility.isReduceTransparencyEnabled
        
        // Get current content size category
        if let contentSizeCategory = UIApplication.shared.preferredContentSizeCategory {
            preferredContentSizeCategory = ContentSizeCategory(contentSizeCategory)
        }
    }
}

// MARK: - Supporting Types

enum SearchAction {
    case search
    case voiceSearch
    case imageSearch
    case filter
    case clearSearch
    case loadMore
    case suggestion
    case favorite
    case share
}

enum FontStyle {
    case title
    case body
    case caption
    
    var baseFont: Font {
        switch self {
        case .title: return .title
        case .body: return .body
        case .caption: return .caption
        }
    }
    
    var sizes: FontSizes {
        switch self {
        case .title: return FontSizes.title
        case .body: return FontSizes.body
        case .caption: return FontSizes.caption
        }
    }
}

struct FontSizes {
    static let title = FontSizes(
        extraSmall: 16,
        small: 18,
        medium: 20,
        large: 22,
        extraLarge: 24,
        extraExtraLarge: 26,
        extraExtraExtraLarge: 28,
        accessibilityMedium: 30,
        accessibilityLarge: 32,
        accessibilityExtraLarge: 34,
        accessibilityExtraExtraLarge: 36,
        accessibilityExtraExtraExtraLarge: 38
    )
    
    static let body = FontSizes(
        extraSmall: 12,
        small: 14,
        medium: 16,
        large: 18,
        extraLarge: 20,
        extraExtraLarge: 22,
        extraExtraExtraLarge: 24,
        accessibilityMedium: 26,
        accessibilityLarge: 28,
        accessibilityExtraLarge: 30,
        accessibilityExtraExtraLarge: 32,
        accessibilityExtraExtraExtraLarge: 34
    )
    
    static let caption = FontSizes(
        extraSmall: 10,
        small: 11,
        medium: 12,
        large: 13,
        extraLarge: 14,
        extraExtraLarge: 15,
        extraExtraExtraLarge: 16,
        accessibilityMedium: 18,
        accessibilityLarge: 20,
        accessibilityExtraLarge: 22,
        accessibilityExtraExtraLarge: 24,
        accessibilityExtraExtraExtraLarge: 26
    )
    
    let extraSmall: CGFloat
    let small: CGFloat
    let medium: CGFloat
    let large: CGFloat
    let extraLarge: CGFloat
    let extraExtraLarge: CGFloat
    let extraExtraExtraLarge: CGFloat
    let accessibilityMedium: CGFloat
    let accessibilityLarge: CGFloat
    let accessibilityExtraLarge: CGFloat
    let accessibilityExtraExtraLarge: CGFloat
    let accessibilityExtraExtraExtraLarge: CGFloat
}

enum ContentSizeCategory {
    case extraSmall
    case small
    case medium
    case large
    case extraLarge
    case extraExtraLarge
    case extraExtraExtraLarge
    case accessibilityMedium
    case accessibilityLarge
    case accessibilityExtraLarge
    case accessibilityExtraExtraLarge
    case accessibilityExtraExtraExtraLarge
    
    init(_ category: UIContentSizeCategory) {
        switch category {
        case .extraSmall: self = .extraSmall
        case .small: self = .small
        case .medium: self = .medium
        case .large: self = .large
        case .extraLarge: self = .extraLarge
        case .extraExtraLarge: self = .extraExtraLarge
        case .extraExtraExtraLarge: self = .extraExtraExtraLarge
        case .accessibilityMedium: self = .accessibilityMedium
        case .accessibilityLarge: self = .accessibilityLarge
        case .accessibilityExtraLarge: self = .accessibilityExtraLarge
        case .accessibilityExtraExtraLarge: self = .accessibilityExtraExtraLarge
        case .accessibilityExtraExtraExtraLarge: self = .accessibilityExtraExtraExtraLarge
        default: self = .medium
        }
    }
}

// MARK: - Extensions

extension Font {
    func size(_ size: CGFloat) -> Font {
        return .system(size: size)
    }
}

extension SearchAccessibilityManager {
    /// Mock data for previews
    static let mock = SearchAccessibilityManager()
}
