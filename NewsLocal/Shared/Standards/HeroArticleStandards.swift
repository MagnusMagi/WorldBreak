//
//  HeroArticleStandards.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI
import Foundation

/// Standardization system for hero articles
/// Defines rules, guidelines, and utilities for consistent hero article display
struct HeroArticleStandards {
    
    // MARK: - Hero Article Types
    
    /// Defines different types of hero articles based on content and priority
    enum HeroArticleType: String, CaseIterable {
        case breaking = "breaking"
        case featured = "featured"
        case trending = "trending"
        case editorial = "editorial"
        case sponsored = "sponsored"
        
        var displayName: String {
            switch self {
            case .breaking: return "Breaking News Hero"
            case .featured: return "Featured Article Hero"
            case .trending: return "Trending Article Hero"
            case .editorial: return "Editorial Hero"
            case .sponsored: return "Sponsored Content Hero"
            }
        }
        
        var priority: Int {
            switch self {
            case .breaking: return 1
            case .featured: return 2
            case .trending: return 3
            case .editorial: return 4
            case .sponsored: return 5
            }
        }
    }
    
    // MARK: - Layout Standards
    
    /// Standard dimensions and ratios for hero articles
    struct Layout {
        static let aspectRatio: CGFloat = 16/9
        static let minHeight: CGFloat = 240
        static let maxHeight: CGFloat = 320
        static let standardHeight: CGFloat = 280
        
        static let cornerRadius: CGFloat = DesignSystem.Spacing.md
        static let shadowRadius: CGFloat = 8
        static let shadowOffset: CGSize = CGSize(width: 0, height: 4)
    }
    
    /// Standard spacing and padding for hero articles
    struct Spacing {
        static let contentPadding: CGFloat = DesignSystem.Spacing.lg
        static let badgeSpacing: CGFloat = DesignSystem.Spacing.sm
        static let metaSpacing: CGFloat = DesignSystem.Spacing.md
        static let titleSpacing: CGFloat = DesignSystem.Spacing.sm
        static let elementSpacing: CGFloat = DesignSystem.Spacing.xs
    }
    
    /// Standard typography for hero articles
    struct Typography {
        static let titleFont = DesignSystem.Typography.title2
        static let titleWeight: Font.Weight = .bold
        static let titleLineLimit: Int = 3
        
        static let categoryFont = DesignSystem.Typography.xs
        static let categoryWeight: Font.Weight = .medium
        
        static let metaFont = DesignSystem.Typography.xs
        static let metaWeight: Font.Weight = .medium
        
        static let breakingFont = DesignSystem.Typography.xs
        static let breakingWeight: Font.Weight = .bold
    }
    
    // MARK: - Visual Standards
    
    /// Standard colors and gradients for hero articles
    struct Colors {
        static let gradientColors = [
            Color.clear,
            Color.black.opacity(0.3),
            Color.black.opacity(0.7)
        ]
        
        static let placeholderGradient = LinearGradient(
            colors: [
                DesignSystem.Colors.primary.opacity(0.3),
                DesignSystem.Colors.primary.opacity(0.1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let categoryBackground = Color.white.opacity(0.2)
        static let breakingBackground = DesignSystem.Colors.breakingNews
        static let textColor = Color.white
        static let metaTextColor = Color.white.opacity(0.8)
        static let separatorColor = Color.white.opacity(0.6)
    }
    
    // MARK: - Content Standards
    
    /// Standard content requirements for hero articles
    struct Content {
        static let minTitleLength = 20
        static let maxTitleLength = 120
        static let requiredImageAspectRatio: CGFloat = 16/9
        static let minImageWidth: CGFloat = 400
        static let minImageHeight: CGFloat = 225
        
        static let supportedCategories: [NewsCategory] = [
            .politics, .business, .technology, .health, .world, .sports, .entertainment
        ]
    }
    
    // MARK: - Quality Standards
    
    /// Quality scoring system for hero articles
    struct Quality {
        static let maxScore: Double = 100.0
        
        // Scoring weights
        static let imageQualityWeight: Double = 0.3
        static let titleQualityWeight: Double = 0.25
        static let recencyWeight: Double = 0.2
        static let sourceCredibilityWeight: Double = 0.15
        static let categoryRelevanceWeight: Double = 0.1
        
        // Minimum thresholds
        static let minImageQualityScore: Double = 60.0
        static let minTitleQualityScore: Double = 70.0
        static let minOverallScore: Double = 75.0
    }
    
    // MARK: - Validation Results
    
    /// Result of hero article validation
    struct ValidationResult {
        let isValid: Bool
        let score: Double
        let issues: [ValidationIssue]
        let recommendations: [String]
        
        var qualityLevel: QualityLevel {
            switch score {
            case 90...100: return .excellent
            case 80..<90: return .good
            case 70..<80: return .acceptable
            case 60..<70: return .poor
            default: return .unacceptable
            }
        }
    }
    
    enum QualityLevel: String, CaseIterable {
        case excellent = "excellent"
        case good = "good"
        case acceptable = "acceptable"
        case poor = "poor"
        case unacceptable = "unacceptable"
        
        var displayName: String {
            switch self {
            case .excellent: return "Excellent"
            case .good: return "Good"
            case .acceptable: return "Acceptable"
            case .poor: return "Poor"
            case .unacceptable: return "Unacceptable"
            }
        }
        
        var color: Color {
            switch self {
            case .excellent: return DesignSystem.Colors.success
            case .good: return DesignSystem.Colors.primary
            case .acceptable: return DesignSystem.Colors.warning
            case .poor: return DesignSystem.Colors.error
            case .unacceptable: return DesignSystem.Colors.textTertiary
            }
        }
    }
    
    enum ValidationIssue: String, CaseIterable {
        case lowImageQuality = "low_image_quality"
        case poorTitle = "poor_title"
        case outdatedContent = "outdated_content"
        case lowSourceCredibility = "low_source_credibility"
        case irrelevantCategory = "irrelevant_category"
        case missingImage = "missing_image"
        case titleTooShort = "title_too_short"
        case titleTooLong = "title_too_long"
        
        var displayName: String {
            switch self {
            case .lowImageQuality: return "Low Image Quality"
            case .poorTitle: return "Poor Title Quality"
            case .outdatedContent: return "Outdated Content"
            case .lowSourceCredibility: return "Low Source Credibility"
            case .irrelevantCategory: return "Irrelevant Category"
            case .missingImage: return "Missing Image"
            case .titleTooShort: return "Title Too Short"
            case .titleTooLong: return "Title Too Long"
            }
        }
        
        var severity: IssueSeverity {
            switch self {
            case .missingImage, .titleTooShort: return .critical
            case .lowImageQuality, .poorTitle: return .high
            case .outdatedContent, .lowSourceCredibility: return .medium
            case .irrelevantCategory, .titleTooLong: return .low
            }
        }
    }
    
    enum IssueSeverity: String, CaseIterable {
        case critical = "critical"
        case high = "high"
        case medium = "medium"
        case low = "low"
        
        var displayName: String {
            switch self {
            case .critical: return "Critical"
            case .high: return "High"
            case .medium: return "Medium"
            case .low: return "Low"
            }
        }
        
        var color: Color {
            switch self {
            case .critical: return DesignSystem.Colors.error
            case .high: return DesignSystem.Colors.warning
            case .medium: return DesignSystem.Colors.primary
            case .low: return DesignSystem.Colors.textSecondary
            }
        }
    }
    
    // MARK: - Selection Criteria
    
    /// Criteria for selecting articles as hero articles
    struct SelectionCriteria {
        static let minEngagementScore: Double = 70.0
        static let maxAgeInHours: Double = 24.0
        static let minSourceCredibility: Double = 0.7
        static let preferredCategories: [NewsCategory] = [
            .politics, .business, .technology, .world
        ]
        
        static let breakingNewsPriority: Double = 1.5
        static let featuredContentPriority: Double = 1.2
        static let trendingContentPriority: Double = 1.1
    }
    
    // MARK: - Validation Methods
    
    /// Validates a hero article against quality standards
    static func validateHeroArticle(_ article: NewsArticle) -> ValidationResult {
        var issues: [ValidationIssue] = []
        var recommendations: [String] = []
        var score: Double = 100.0
        
        // Image quality validation
        let imageScore = validateImageQuality(article)
        if imageScore < Quality.minImageQualityScore {
            issues.append(.lowImageQuality)
            recommendations.append("Use a higher quality image with 16:9 aspect ratio")
            score -= 20.0
        }
        
        if article.imageUrl == nil {
            issues.append(.missingImage)
            recommendations.append("Add a compelling hero image")
            score -= 30.0
        }
        
        // Title quality validation
        let titleScore = validateTitleQuality(article.title)
        if titleScore < Quality.minTitleQualityScore {
            issues.append(.poorTitle)
            recommendations.append("Improve title clarity and engagement")
            score -= 15.0
        }
        
        if article.title.count < Content.minTitleLength {
            issues.append(.titleTooShort)
            recommendations.append("Make title more descriptive")
            score -= 10.0
        }
        
        if article.title.count > Content.maxTitleLength {
            issues.append(.titleTooLong)
            recommendations.append("Shorten title for better readability")
            score -= 5.0
        }
        
        // Content recency validation
        let hoursSincePublished = Date().timeIntervalSince(article.publishedAt) / 3600
        if hoursSincePublished > SelectionCriteria.maxAgeInHours {
            issues.append(.outdatedContent)
            recommendations.append("Consider using more recent content")
            score -= 10.0
        }
        
        // Source credibility validation
        if article.source.credibilityScore < SelectionCriteria.minSourceCredibility {
            issues.append(.lowSourceCredibility)
            recommendations.append("Verify source credibility")
            score -= 15.0
        }
        
        // Category relevance validation
        if !Content.supportedCategories.contains(article.category) {
            issues.append(.irrelevantCategory)
            recommendations.append("Consider using a more relevant category")
            score -= 5.0
        }
        
        let isValid = score >= Quality.minOverallScore && !issues.contains { $0.severity == .critical }
        
        return ValidationResult(
            isValid: isValid,
            score: max(0, min(100, score)),
            issues: issues,
            recommendations: recommendations
        )
    }
    
    /// Validates image quality for hero articles
    private static func validateImageQuality(_ article: NewsArticle) -> Double {
        guard let imageUrl = article.imageUrl else { return 0.0 }
        
        // Basic validation - in a real app, you'd analyze the actual image
        var score: Double = 50.0
        
        // Check if URL is valid
        if imageUrl.absoluteString.contains("unsplash.com") {
            score += 20.0 // Assume Unsplash images are good quality
        }
        
        // Check if URL suggests high resolution
        if imageUrl.absoluteString.contains("w=800") || imageUrl.absoluteString.contains("w=1200") {
            score += 20.0
        }
        
        // Check if URL suggests proper aspect ratio
        if imageUrl.absoluteString.contains("16:9") || imageUrl.absoluteString.contains("aspect_ratio=16:9") {
            score += 10.0
        }
        
        return min(100.0, score)
    }
    
    /// Validates title quality for hero articles
    private static func validateTitleQuality(_ title: String) -> Double {
        var score: Double = 50.0
        
        // Length check
        if title.count >= Content.minTitleLength && title.count <= Content.maxTitleLength {
            score += 20.0
        }
        
        // Engagement indicators
        let engagementWords = ["breaking", "exclusive", "urgent", "major", "significant", "important"]
        let hasEngagementWords = engagementWords.contains { title.lowercased().contains($0) }
        if hasEngagementWords {
            score += 15.0
        }
        
        // Clarity indicators
        let hasQuestionMark = title.contains("?")
        let hasExclamation = title.contains("!")
        if !hasQuestionMark && !hasExclamation {
            score += 10.0 // Prefer declarative statements
        }
        
        // Word count
        let wordCount = title.components(separatedBy: .whitespaces).count
        if wordCount >= 5 && wordCount <= 15 {
            score += 15.0
        }
        
        return min(100.0, score)
    }
    
    /// Determines the appropriate hero article type for an article
    static func determineHeroType(_ article: NewsArticle) -> HeroArticleType {
        if article.isBreaking {
            return .breaking
        }
        
        // Check if it's trending (this would be determined by analytics)
        // For now, we'll use a simple heuristic
        let hoursSincePublished = Date().timeIntervalSince(article.publishedAt) / 3600
        if hoursSincePublished < 2 {
            return .trending
        }
        
        // Check if it's from a high-credibility source
        if article.source.credibilityScore > 0.8 {
            return .featured
        }
        
        // Default to editorial
        return .editorial
    }
    
    /// Calculates the priority score for hero article selection
    static func calculatePriorityScore(_ article: NewsArticle) -> Double {
        var score: Double = 0.0
        
        // Base score
        score += 50.0
        
        // Breaking news bonus
        if article.isBreaking {
            score += 30.0
        }
        
        // Recency bonus
        let hoursSincePublished = Date().timeIntervalSince(article.publishedAt) / 3600
        if hoursSincePublished < 1 {
            score += 20.0
        } else if hoursSincePublished < 6 {
            score += 15.0
        } else if hoursSincePublished < 12 {
            score += 10.0
        }
        
        // Source credibility bonus
        score += article.source.credibilityScore * 20.0
        
        // Category preference bonus
        if SelectionCriteria.preferredCategories.contains(article.category) {
            score += 10.0
        }
        
        // Title quality bonus
        let titleScore = validateTitleQuality(article.title)
        score += titleScore * 0.1
        
        return min(100.0, score)
    }
}

// MARK: - Extensions

extension HeroArticleStandards {
    /// Provides styling for different hero article types
    static func styling(for type: HeroArticleType) -> HeroArticleStyling {
        switch type {
        case .breaking:
            return HeroArticleStyling(
                badgeColor: DesignSystem.Colors.breakingNews,
                badgeText: "BREAKING",
                priority: 1,
                animation: .pulse
            )
        case .featured:
            return HeroArticleStyling(
                badgeColor: DesignSystem.Colors.primary,
                badgeText: "FEATURED",
                priority: 2,
                animation: .none
            )
        case .trending:
            return HeroArticleStyling(
                badgeColor: DesignSystem.Colors.warning,
                badgeText: "TRENDING",
                priority: 3,
                animation: .glow
            )
        case .editorial:
            return HeroArticleStyling(
                badgeColor: DesignSystem.Colors.textSecondary,
                badgeText: "EDITORIAL",
                priority: 4,
                animation: .none
            )
        case .sponsored:
            return HeroArticleStyling(
                badgeColor: DesignSystem.Colors.success,
                badgeText: "SPONSORED",
                priority: 5,
                animation: .none
            )
        }
    }
}

/// Styling configuration for hero articles
struct HeroArticleStyling {
    let badgeColor: Color
    let badgeText: String
    let priority: Int
    let animation: HeroAnimation
}

enum HeroAnimation: String, CaseIterable {
    case none = "none"
    case pulse = "pulse"
    case glow = "glow"
    case slide = "slide"
    
    var displayName: String {
        switch self {
        case .none: return "None"
        case .pulse: return "Pulse"
        case .glow: return "Glow"
        case .slide: return "Slide"
        }
    }
}
