//
//  HomepageArticleManager.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

/// Manages homepage article selection, organization, and display based on standards
@MainActor
class HomepageArticleManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var heroArticle: NewsArticle?
    @Published var breakingNews: [NewsArticle] = []
    @Published var trendingArticles: [NewsArticle] = []
    @Published var categoryArticles: [NewsCategory: [NewsArticle]] = [:]
    @Published var feedArticles: [NewsArticle] = []
    @Published var isLoading = false
    @Published var error: AppError?
    
    // MARK: - Private Properties
    
    private let newsService: NewsServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var allArticles: [NewsArticle] = []
    
    // MARK: - Initialization
    
    init(newsService: NewsServiceProtocol = ServiceFactory.createNewsService(isMock: true)) {
        self.newsService = newsService
    }
    
    // MARK: - Public Methods
    
    /// Loads and organizes all homepage articles
    func loadHomepageArticles() {
        isLoading = true
        error = nil
        
        fetchAllArticles()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error as? AppError ?? AppError.unknown("Failed to load articles")
                    }
                },
                receiveValue: { [weak self] articles in
                    Task { @MainActor in
                        await self?.organizeArticles(articles)
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    /// Refreshes specific section
    func refreshSection(_ placement: HomepageArticleStandards.ArticlePlacement) {
        fetchArticlesForPlacement(placement)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error as? AppError ?? AppError.unknown("Failed to refresh section")
                    }
                },
                receiveValue: { [weak self] articles in
                    Task { @MainActor in
                        await self?.updateSection(placement, with: articles)
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    /// Gets articles for a specific placement
    func getArticles(for placement: HomepageArticleStandards.ArticlePlacement) -> [NewsArticle] {
        switch placement {
        case .hero:
            return heroArticle.map { [$0] } ?? []
        case .breaking:
            return breakingNews
        case .trending:
            return trendingArticles
        case .category:
            return Array(categoryArticles.values.flatMap { $0 })
        case .feed:
            return feedArticles
        }
    }
    
    /// Gets card type for an article
    func getCardType(for article: NewsArticle, placement: HomepageArticleStandards.ArticlePlacement) -> HomepageArticleStandards.ArticleCardType {
        return HomepageArticleStandards.cardType(for: article, placement: placement)
    }
    
    /// Validates article quality
    func validateArticle(_ article: NewsArticle) -> ArticleValidationResult {
        return HomepageArticleStandards.validateArticle(article)
    }
    
    // MARK: - Private Methods
    
    private func fetchAllArticles() -> AnyPublisher<[NewsArticle], Error> {
        let categoryPublishers = NewsCategory.allCases.map { category in
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
    
    private func fetchArticlesForPlacement(_ placement: HomepageArticleStandards.ArticlePlacement) -> AnyPublisher<[NewsArticle], Error> {
        switch placement {
        case .hero, .breaking, .trending, .feed:
            return newsService.fetchTopHeadlines(category: nil)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        case .category:
            let categoryPublishers = NewsCategory.allCases.map { category in
                newsService.fetchTopHeadlines(category: category)
                    .mapError { $0 as Error }
            }
            
            return Publishers.MergeMany(categoryPublishers)
                .collect()
                .map { articleArrays in
                    articleArrays.flatMap { $0 }
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func organizeArticles(_ articles: [NewsArticle]) async {
        allArticles = articles
        
        // Select hero article
        let heroCandidates = HomepageArticleStandards.selectArticles(
            from: articles,
            for: .hero,
            limit: 1
        )
        heroArticle = heroCandidates.first
        
        // Select breaking news
        breakingNews = HomepageArticleStandards.selectArticles(
            from: articles,
            for: .breaking
        )
        
        // Select trending articles
        trendingArticles = HomepageArticleStandards.selectArticles(
            from: articles,
            for: .trending
        )
        
        // Organize category articles
        await organizeCategoryArticles(articles)
        
        // Select feed articles
        feedArticles = HomepageArticleStandards.selectArticles(
            from: articles,
            for: .feed
        )
    }
    
    private func organizeCategoryArticles(_ articles: [NewsArticle]) async {
        var categoryArticles: [NewsCategory: [NewsArticle]] = [:]
        
        for category in NewsCategory.allCases.prefix(4) {
            let categorySpecificArticles = articles.filter { $0.category == category }
            let selectedArticles = HomepageArticleStandards.selectArticles(
                from: categorySpecificArticles,
                for: .category
            )
            categoryArticles[category] = selectedArticles
        }
        
        self.categoryArticles = categoryArticles
    }
    
    private func updateSection(_ placement: HomepageArticleStandards.ArticlePlacement, with articles: [NewsArticle]) async {
        switch placement {
        case .hero:
            let selected = HomepageArticleStandards.selectArticles(
                from: articles,
                for: .hero,
                limit: 1
            )
            heroArticle = selected.first
            
        case .breaking:
            breakingNews = HomepageArticleStandards.selectArticles(
                from: articles,
                for: .breaking
            )
            
        case .trending:
            trendingArticles = HomepageArticleStandards.selectArticles(
                from: articles,
                for: .trending
            )
            
        case .category:
            await organizeCategoryArticles(articles)
            
        case .feed:
            feedArticles = HomepageArticleStandards.selectArticles(
                from: articles,
                for: .feed
            )
        }
    }
}

// MARK: - Article Quality Metrics

extension HomepageArticleManager {
    
    /// Gets quality metrics for the current homepage
    func getQualityMetrics() -> HomepageQualityMetrics {
        let allDisplayedArticles = getAllDisplayedArticles()
        
        let totalArticles = allDisplayedArticles.count
        let articlesWithImages = allDisplayedArticles.filter { $0.imageUrl != nil }.count
        let verifiedSources = allDisplayedArticles.filter { $0.source.isVerified }.count
        let breakingNewsCount = allDisplayedArticles.filter { $0.isBreaking }.count
        
        let averageScore = allDisplayedArticles.compactMap { article in
            HomepageArticleStandards.ArticleScore.calculate(
                for: article,
                criteria: HomepageArticleStandards.ArticleSelectionCriteria.feed
            ).total
        }.reduce(0, +) / Double(max(totalArticles, 1))
        
        return HomepageQualityMetrics(
            totalArticles: totalArticles,
            articlesWithImages: articlesWithImages,
            verifiedSources: verifiedSources,
            breakingNewsCount: breakingNewsCount,
            averageQualityScore: averageScore,
            lastUpdated: Date()
        )
    }
    
    private func getAllDisplayedArticles() -> [NewsArticle] {
        var articles: [NewsArticle] = []
        
        if let hero = heroArticle {
            articles.append(hero)
        }
        
        articles.append(contentsOf: breakingNews)
        articles.append(contentsOf: trendingArticles)
        articles.append(contentsOf: Array(categoryArticles.values.flatMap { $0 }))
        articles.append(contentsOf: feedArticles)
        
        return articles
    }
}

// MARK: - Supporting Types

struct HomepageQualityMetrics {
    let totalArticles: Int
    let articlesWithImages: Int
    let verifiedSources: Int
    let breakingNewsCount: Int
    let averageQualityScore: Double
    let lastUpdated: Date
    
    var imageCoverage: Double {
        return totalArticles > 0 ? Double(articlesWithImages) / Double(totalArticles) : 0
    }
    
    var sourceVerificationRate: Double {
        return totalArticles > 0 ? Double(verifiedSources) / Double(totalArticles) : 0
    }
    
    var qualityGrade: String {
        switch averageQualityScore {
        case 0.8...1.0: return "A+"
        case 0.7..<0.8: return "A"
        case 0.6..<0.7: return "B"
        case 0.5..<0.6: return "C"
        case 0.4..<0.5: return "D"
        default: return "F"
        }
    }
}

