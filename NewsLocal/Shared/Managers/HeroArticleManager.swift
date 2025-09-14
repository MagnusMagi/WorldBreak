//
//  HeroArticleManager.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

/// Manages hero article selection, validation, and display based on standards
@MainActor
class HeroArticleManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currentHeroArticle: NewsArticle?
    @Published var heroArticleType: HeroArticleStandards.HeroArticleType = .featured
    @Published var validationResult: HeroArticleStandards.ValidationResult?
    @Published var isLoading = false
    @Published var error: AppError?
    
    // MARK: - Private Properties
    
    private let newsService: NewsServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(newsService: NewsServiceProtocol = NewsService()) {
        self.newsService = newsService
    }
    
    // MARK: - Public Methods
    
    /// Loads and selects the best hero article
    func loadHeroArticle() {
        isLoading = true
        error = nil
        
        fetchCandidateArticles()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error as? AppError ?? AppError.unknown("Failed to load hero article")
                    }
                },
                receiveValue: { [weak self] articles in
                    self?.selectBestHeroArticle(from: articles)
                }
            )
            .store(in: &cancellables)
    }
    
    /// Refreshes the current hero article
    func refreshHeroArticle() {
        loadHeroArticle()
    }
    
    /// Validates the current hero article
    func validateCurrentHeroArticle() {
        guard let article = currentHeroArticle else { return }
        validationResult = HeroArticleStandards.validateHeroArticle(article)
    }
    
    /// Gets styling for the current hero article type
    func getCurrentStyling() -> HeroArticleStyling {
        return HeroArticleStandards.styling(for: heroArticleType)
    }
    
    /// Checks if the current hero article meets quality standards
    var meetsQualityStandards: Bool {
        guard let result = validationResult else { return false }
        return result.isValid && result.score >= HeroArticleStandards.Quality.minOverallScore
    }
    
    /// Gets quality recommendations for the current hero article
    var qualityRecommendations: [String] {
        return validationResult?.recommendations ?? []
    }
    
    // MARK: - Private Methods
    
    private func fetchCandidateArticles() -> AnyPublisher<[NewsArticle], Error> {
        let categoryPublishers = HeroArticleStandards.Content.supportedCategories.map { category in
            newsService.fetchTopHeadlines(category: category)
                .mapError { $0 as Error }
        }
        
        let generalPublisher = newsService.fetchTopHeadlines(category: nil)
            .mapError { $0 as Error }
        
        let allPublishers = categoryPublishers + [generalPublisher]
        
        return Publishers.MergeMany(allPublishers)
            .collect()
            .map { articleArrays in
                articleArrays.flatMap { $0 }
            }
            .eraseToAnyPublisher()
    }
    
    private func selectBestHeroArticle(from articles: [NewsArticle]) {
        // Filter articles that meet basic criteria
        let candidateArticles = articles.filter { article in
            let hoursSincePublished = Date().timeIntervalSince(article.publishedAt) / 3600
            return hoursSincePublished <= HeroArticleStandards.SelectionCriteria.maxAgeInHours &&
                   article.source.credibilityScore >= HeroArticleStandards.SelectionCriteria.minSourceCredibility
        }
        
        // Sort by priority score
        let sortedArticles = candidateArticles.sorted { article1, article2 in
            let score1 = HeroArticleStandards.calculatePriorityScore(article1)
            let score2 = HeroArticleStandards.calculatePriorityScore(article2)
            return score1 > score2
        }
        
        // Select the best article
        if let bestArticle = sortedArticles.first {
            currentHeroArticle = bestArticle
            heroArticleType = HeroArticleStandards.determineHeroType(bestArticle)
            validateCurrentHeroArticle()
        } else {
            error = AppError.unknown("No suitable hero article found")
        }
    }
    
    /// Gets analytics data for hero article performance
    func getHeroArticleAnalytics() -> HeroArticleAnalytics {
        guard let article = currentHeroArticle else {
            return HeroArticleAnalytics.empty
        }
        
        return HeroArticleAnalytics(
            articleId: article.id,
            articleType: heroArticleType,
            qualityScore: validationResult?.score ?? 0.0,
            validationIssues: validationResult?.issues ?? [],
            recommendations: validationResult?.recommendations ?? [],
            timestamp: Date()
        )
    }
}

// MARK: - Analytics

/// Analytics data for hero article performance
struct HeroArticleAnalytics {
    let articleId: String
    let articleType: HeroArticleStandards.HeroArticleType
    let qualityScore: Double
    let validationIssues: [HeroArticleStandards.ValidationIssue]
    let recommendations: [String]
    let timestamp: Date
    
    static let empty = HeroArticleAnalytics(
        articleId: "",
        articleType: .featured,
        qualityScore: 0.0,
        validationIssues: [],
        recommendations: [],
        timestamp: Date()
    )
    
    var qualityLevel: HeroArticleStandards.QualityLevel {
        switch qualityScore {
        case 90...100: return .excellent
        case 80..<90: return .good
        case 70..<80: return .acceptable
        case 60..<70: return .poor
        default: return .unacceptable
        }
    }
    
    var hasCriticalIssues: Bool {
        return validationIssues.contains { $0.severity == .critical }
    }
    
    var hasHighPriorityIssues: Bool {
        return validationIssues.contains { $0.severity == .high || $0.severity == .critical }
    }
}

// MARK: - Extensions

extension HeroArticleManager {
    /// Gets a summary of the current hero article's quality
    func getQualitySummary() -> String {
        guard let result = validationResult else {
            return "No validation data available"
        }
        
        let qualityLevel = result.qualityLevel
        let issueCount = result.issues.count
        
        if issueCount == 0 {
            return "\(qualityLevel.displayName) quality - No issues found"
        } else {
            return "\(qualityLevel.displayName) quality - \(issueCount) issue\(issueCount == 1 ? "" : "s") found"
        }
    }
    
    /// Gets the most critical issue that needs attention
    func getMostCriticalIssue() -> HeroArticleStandards.ValidationIssue? {
        return validationResult?.issues
            .sorted { $0.severity.rawValue < $1.severity.rawValue }
            .first
    }
    
    /// Checks if the hero article needs immediate attention
    var needsImmediateAttention: Bool {
        guard let result = validationResult else { return false }
        return result.issues.contains { $0.severity == .critical } || result.score < 60.0
    }
}
