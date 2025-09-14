//
//  HomepageArticleStandards.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI
import Foundation

/// Standardization system for homepage articles
/// Defines rules, guidelines, and utilities for consistent article display
struct HomepageArticleStandards {
    
    // MARK: - Article Card Type Standards
    
    /// Defines which article card type to use based on article properties
    enum ArticleCardType: String, CaseIterable {
        case hero = "hero"
        case standard = "standard"
        case compact = "compact"
        case breaking = "breaking"
        
        var displayName: String {
            switch self {
            case .hero: return "Hero Article"
            case .standard: return "Standard Article"
            case .compact: return "Compact Article"
            case .breaking: return "Breaking News"
            }
        }
        
        var description: String {
            switch self {
            case .hero:
                return "Large featured article with 16:9 image, gradient overlay, and prominent display"
            case .standard:
                return "Medium-sized card with 4:3 image, full content, and action buttons"
            case .compact:
                return "Small horizontal card for lists with thumbnail and quick actions"
            case .breaking:
                return "Special styling for urgent news with priority indicators and red accents"
            }
        }
    }
    
    // MARK: - Article Placement Rules
    
    /// Rules for where articles should be placed on the homepage
    enum ArticlePlacement: String, CaseIterable {
        case hero = "hero"
        case trending = "trending"
        case category = "category"
        case feed = "feed"
        case breaking = "breaking"
        
        var priority: Int {
            switch self {
            case .breaking: return 1
            case .hero: return 2
            case .trending: return 3
            case .category: return 4
            case .feed: return 5
            }
        }
        
        var maxArticles: Int {
            switch self {
            case .breaking: return 3
            case .hero: return 1
            case .trending: return 5
            case .category: return 4
            case .feed: return 20
            }
        }
    }
    
    // MARK: - Article Selection Criteria
    
    /// Criteria for selecting articles for different placements
    struct ArticleSelectionCriteria {
        let minReadTime: Int
        let maxReadTime: Int
        let requiredImage: Bool
        let minLikeCount: Int
        let maxAge: TimeInterval
        let priorityCategories: [NewsCategory]
        let excludeCategories: [NewsCategory]
        
        static let hero = ArticleSelectionCriteria(
            minReadTime: 3,
            maxReadTime: 15,
            requiredImage: true,
            minLikeCount: 10,
            maxAge: 24 * 3600, // 24 hours
            priorityCategories: [.technology, .business, .world, .politics],
            excludeCategories: []
        )
        
        static let trending = ArticleSelectionCriteria(
            minReadTime: 1,
            maxReadTime: 10,
            requiredImage: false,
            minLikeCount: 5,
            maxAge: 7 * 24 * 3600, // 7 days
            priorityCategories: NewsCategory.allCases,
            excludeCategories: []
        )
        
        static let category = ArticleSelectionCriteria(
            minReadTime: 2,
            maxReadTime: 12,
            requiredImage: true,
            minLikeCount: 3,
            maxAge: 3 * 24 * 3600, // 3 days
            priorityCategories: [],
            excludeCategories: []
        )
        
        static let feed = ArticleSelectionCriteria(
            minReadTime: 1,
            maxReadTime: 20,
            requiredImage: false,
            minLikeCount: 0,
            maxAge: 30 * 24 * 3600, // 30 days
            priorityCategories: [],
            excludeCategories: []
        )
        
        static let breaking = ArticleSelectionCriteria(
            minReadTime: 1,
            maxReadTime: 8,
            requiredImage: true,
            minLikeCount: 0,
            maxAge: 2 * 3600, // 2 hours
            priorityCategories: [.politics, .world, .technology, .health],
            excludeCategories: [.entertainment, .sports]
        )
    }
    
    // MARK: - Article Scoring System
    
    /// Scoring system for article prioritization
    struct ArticleScore {
        let relevance: Double
        let recency: Double
        let engagement: Double
        let quality: Double
        let breaking: Double
        
        var total: Double {
            return (relevance * 0.3) + (recency * 0.25) + (engagement * 0.2) + (quality * 0.15) + (breaking * 0.1)
        }
        
        static func calculate(for article: NewsArticle, criteria: ArticleSelectionCriteria) -> ArticleScore {
            let relevance = calculateRelevance(article: article, criteria: criteria)
            let recency = calculateRecency(article: article, criteria: criteria)
            let engagement = calculateEngagement(article: article, criteria: criteria)
            let quality = calculateQuality(article: article, criteria: criteria)
            let breaking = calculateBreaking(article: article, criteria: criteria)
            
            return ArticleScore(
                relevance: relevance,
                recency: recency,
                engagement: engagement,
                quality: quality,
                breaking: breaking
            )
        }
        
        private static func calculateRelevance(article: NewsArticle, criteria: ArticleSelectionCriteria) -> Double {
            var score = 0.5 // Base score
            
            // Category priority
            if criteria.priorityCategories.contains(article.category) {
                score += 0.3
            }
            
            // Exclude categories
            if criteria.excludeCategories.contains(article.category) {
                score -= 0.5
            }
            
            return max(0, min(1, score))
        }
        
        private static func calculateRecency(article: NewsArticle, criteria: ArticleSelectionCriteria) -> Double {
            let age = Date().timeIntervalSince(article.publishedAt)
            let maxAge = criteria.maxAge
            
            if age > maxAge {
                return 0
            }
            
            return 1 - (age / maxAge)
        }
        
        private static func calculateEngagement(article: NewsArticle, criteria: ArticleSelectionCriteria) -> Double {
            let likeScore = min(1.0, Double(article.likeCount) / 100.0)
            let shareScore = min(1.0, Double(article.shareCount) / 50.0)
            
            return (likeScore + shareScore) / 2
        }
        
        private static func calculateQuality(article: NewsArticle, criteria: ArticleSelectionCriteria) -> Double {
            var score = 0.5 // Base score
            
            // Image quality
            if article.imageUrl != nil {
                score += 0.2
            }
            
            // Content length
            let readTime = article.readingTime
            if readTime >= criteria.minReadTime && readTime <= criteria.maxReadTime {
                score += 0.2
            }
            
            // Source credibility
            if article.source.isVerified {
                score += 0.1
            }
            
            return max(0, min(1, score))
        }
        
        private static func calculateBreaking(article: NewsArticle, criteria: ArticleSelectionCriteria) -> Double {
            return article.isBreaking ? 1.0 : 0.0
        }
    }
    
    // MARK: - Article Layout Standards
    
    /// Standard layout configurations for different article types
    struct LayoutStandards {
        static let hero = HeroLayoutStandards()
        static let standard = StandardLayoutStandards()
        static let compact = CompactLayoutStandards()
        static let breaking = BreakingLayoutStandards()
    }
    
    struct HeroLayoutStandards {
        let imageAspectRatio: CGFloat = 16/9
        let imageHeight: CGFloat = 280
        let cornerRadius: CGFloat = 12
        let shadowRadius: CGFloat = 8
        let padding: CGFloat = 16
        let titleLineLimit: Int = 3
        let summaryLineLimit: Int = 2
    }
    
    struct StandardLayoutStandards {
        let imageAspectRatio: CGFloat = 4/3
        let imageWidth: CGFloat = 120
        let imageHeight: CGFloat = 90
        let cornerRadius: CGFloat = 8
        let shadowRadius: CGFloat = 2
        let padding: CGFloat = 16
        let titleLineLimit: Int = 3
        let summaryLineLimit: Int = 2
    }
    
    struct CompactLayoutStandards {
        let imageSize: CGFloat = 60
        let cornerRadius: CGFloat = 4
        let shadowRadius: CGFloat = 1
        let padding: CGFloat = 12
        let titleLineLimit: Int = 2
        let summaryLineLimit: Int = 1
    }
    
    struct BreakingLayoutStandards {
        let imageAspectRatio: CGFloat = 4/3
        let imageWidth: CGFloat = 100
        let imageHeight: CGFloat = 75
        let cornerRadius: CGFloat = 6
        let shadowRadius: CGFloat = 4
        let padding: CGFloat = 16
        let titleLineLimit: Int = 3
        let summaryLineLimit: Int = 2
        let borderWidth: CGFloat = 2
    }
    
    // MARK: - Content Standards
    
    /// Content quality and formatting standards
    struct ContentStandards {
        static let maxTitleLength = 100
        static let maxSummaryLength = 200
        static let minTitleLength = 10
        static let minSummaryLength = 20
        
        static func validateTitle(_ title: String) -> Bool {
            return title.count >= minTitleLength && title.count <= maxTitleLength
        }
        
        static func validateSummary(_ summary: String) -> Bool {
            return summary.count >= minSummaryLength && summary.count <= maxSummaryLength
        }
        
        static func truncateTitle(_ title: String) -> String {
            if title.count <= maxTitleLength {
                return title
            }
            let truncated = String(title.prefix(maxTitleLength - 3))
            return truncated + "..."
        }
        
        static func truncateSummary(_ summary: String) -> String {
            if summary.count <= maxSummaryLength {
                return summary
            }
            let truncated = String(summary.prefix(maxSummaryLength - 3))
            return truncated + "..."
        }
    }
    
    // MARK: - Performance Standards
    
    /// Performance optimization standards
    struct PerformanceStandards {
        static let maxConcurrentImageLoads = 5
        static let imageCacheSize = 50
        static let preloadDistance = 3
        static let maxArticlesInMemory = 100
        
        static func shouldPreloadImage(for index: Int, currentIndex: Int) -> Bool {
            return abs(index - currentIndex) <= preloadDistance
        }
    }
    
    // MARK: - Accessibility Standards
    
    /// Accessibility requirements for article cards
    struct AccessibilityStandards {
        static let minTouchTargetSize: CGFloat = 44
        static let minContrastRatio: Double = 4.5
        static let maxAnimationDuration: Double = 0.3
        
        static func validateTouchTarget(_ size: CGSize) -> Bool {
            return size.width >= minTouchTargetSize && size.height >= minTouchTargetSize
        }
    }
}

// MARK: - Article Selection Utilities

extension HomepageArticleStandards {
    
    /// Selects articles for a specific placement based on criteria
    static func selectArticles(
        from articles: [NewsArticle],
        for placement: ArticlePlacement,
        limit: Int? = nil
    ) -> [NewsArticle] {
        let criteria = getCriteria(for: placement)
        let maxCount = limit ?? placement.maxArticles
        
        let scoredArticles = articles.compactMap { article -> (NewsArticle, ArticleScore)? in
            guard meetsCriteria(article, criteria: criteria) else { return nil }
            let score = ArticleScore.calculate(for: article, criteria: criteria)
            return (article, score)
        }
        
        let sortedArticles = scoredArticles
            .sorted { $0.1.total > $1.1.total }
            .prefix(maxCount)
            .map { $0.0 }
        
        return Array(sortedArticles)
    }
    
    /// Determines the appropriate card type for an article
    static func cardType(for article: NewsArticle, placement: ArticlePlacement) -> ArticleCardType {
        switch placement {
        case .breaking:
            return .breaking
        case .hero:
            return .hero
        case .trending, .category, .feed:
            if article.isBreaking {
                return .breaking
            } else if placement == .feed {
                return .compact
            } else {
                return .standard
            }
        }
    }
    
    /// Gets selection criteria for a placement
    private static func getCriteria(for placement: ArticlePlacement) -> ArticleSelectionCriteria {
        switch placement {
        case .hero: return ArticleSelectionCriteria.hero
        case .trending: return ArticleSelectionCriteria.trending
        case .category: return ArticleSelectionCriteria.category
        case .feed: return ArticleSelectionCriteria.feed
        case .breaking: return ArticleSelectionCriteria.breaking
        }
    }
    
    /// Checks if an article meets the selection criteria
    private static func meetsCriteria(_ article: NewsArticle, criteria: ArticleSelectionCriteria) -> Bool {
        // Check read time
        guard article.readingTime >= criteria.minReadTime && article.readingTime <= criteria.maxReadTime else {
            return false
        }
        
        // Check image requirement
        if criteria.requiredImage && article.imageUrl == nil {
            return false
        }
        
        // Check like count
        guard article.likeCount >= criteria.minLikeCount else {
            return false
        }
        
        // Check age
        let age = Date().timeIntervalSince(article.publishedAt)
        guard age <= criteria.maxAge else {
            return false
        }
        
        return true
    }
}

// MARK: - Article Validation

extension HomepageArticleStandards {
    
    /// Validates an article for homepage display
    static func validateArticle(_ article: NewsArticle) -> ArticleValidationResult {
        var issues: [ArticleValidationIssue] = []
        
        // Title validation
        if !ContentStandards.validateTitle(article.title) {
            issues.append(.invalidTitleLength(article.title.count))
        }
        
        // Summary validation
        if !ContentStandards.validateSummary(article.summary) {
            issues.append(.invalidSummaryLength(article.summary.count))
        }
        
        // Image validation
        if article.imageUrl == nil {
            issues.append(.missingImage)
        }
        
        // Source validation
        if !article.source.isVerified {
            issues.append(.unverifiedSource)
        }
        
        return ArticleValidationResult(article: article, issues: issues)
    }
}

// MARK: - Supporting Types

struct ArticleValidationResult {
    let article: NewsArticle
    let issues: [ArticleValidationIssue]
    
    var isValid: Bool {
        return issues.isEmpty
    }
    
    var severity: ValidationSeverity {
        if issues.contains(where: { $0.severity == .critical }) {
            return .critical
        } else if issues.contains(where: { $0.severity == .warning }) {
            return .warning
        } else {
            return .info
        }
    }
}

enum ArticleValidationIssue {
    case invalidTitleLength(Int)
    case invalidSummaryLength(Int)
    case missingImage
    case unverifiedSource
    
    var severity: ValidationSeverity {
        switch self {
        case .invalidTitleLength, .invalidSummaryLength:
            return .warning
        case .missingImage, .unverifiedSource:
            return .info
        }
    }
    
    var description: String {
        switch self {
        case .invalidTitleLength(let count):
            return "Title length (\(count)) is outside recommended range"
        case .invalidSummaryLength(let count):
            return "Summary length (\(count)) is outside recommended range"
        case .missingImage:
            return "Article is missing an image"
        case .unverifiedSource:
            return "Article source is not verified"
        }
    }
}

enum ValidationSeverity {
    case info
    case warning
    case critical
}
