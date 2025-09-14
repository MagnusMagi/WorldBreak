//
//  NewsServiceProtocol.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import Combine

// MARK: - News Service Protocol

/// Protocol defining the interface for news-related operations
protocol NewsServiceProtocol {
    
    // MARK: - News Fetching
    
    /// Fetch top headlines with optional category filter
    /// - Parameter category: Optional category to filter headlines
    /// - Returns: Publisher that emits array of news articles
    func fetchTopHeadlines(category: NewsCategory?) -> AnyPublisher<[NewsArticle], AppError>
    
    /// Fetch breaking news articles
    /// - Returns: Publisher that emits array of breaking news articles
    func fetchBreakingNews() -> AnyPublisher<[NewsArticle], AppError>
    
    /// Fetch trending news articles
    /// - Parameter limit: Maximum number of trending articles to fetch
    /// - Returns: Publisher that emits array of trending news articles
    func fetchTrendingNews(limit: Int?) -> AnyPublisher<[NewsArticle], AppError>
    
    /// Fetch articles by category
    /// - Parameters:
    ///   - category: News category to fetch articles for
    ///   - page: Page number for pagination
    ///   - limit: Number of articles per page
    /// - Returns: Publisher that emits news response with pagination info
    func fetchArticlesByCategory(
        _ category: NewsCategory,
        page: Int,
        limit: Int
    ) -> AnyPublisher<NewsResponse, AppError>
    
    /// Get a specific article by ID
    /// - Parameter id: Article identifier
    /// - Returns: Publisher that emits the requested article
    func getArticle(id: String) -> AnyPublisher<NewsArticle, AppError>
    
    /// Fetch related articles for a given article
    /// - Parameters:
    ///   - article: Article to find related content for
    ///   - limit: Maximum number of related articles
    /// - Returns: Publisher that emits array of related articles
    func fetchRelatedArticles(
        for article: NewsArticle,
        limit: Int
    ) -> AnyPublisher<[NewsArticle], AppError>
    
    /// Fetch related articles by article ID and category
    /// - Parameters:
    ///   - articleId: Article ID to find related content for
    ///   - category: Category to find related articles in
    /// - Returns: Publisher that emits array of related articles
    func fetchRelatedArticles(
        articleId: String,
        category: NewsCategory
    ) -> AnyPublisher<[NewsArticle], AppError>
    
    // MARK: - Search Operations
    
    /// Search articles with query and optional filters
    /// - Parameters:
    ///   - query: Search query string
    ///   - filters: Optional search filters
    ///   - page: Page number for pagination
    ///   - limit: Number of results per page
    /// - Returns: Publisher that emits search results with pagination info
    func searchArticles(
        query: String,
        filters: SearchFilters?,
        page: Int,
        limit: Int
    ) -> AnyPublisher<NewsResponse, AppError>
    
    /// Get search suggestions based on partial query
    /// - Parameter query: Partial search query
    /// - Returns: Publisher that emits array of search suggestions
    func getSearchSuggestions(query: String) -> AnyPublisher<[String], AppError>
    
    /// Get trending search topics
    /// - Parameter limit: Maximum number of trending topics
    /// - Returns: Publisher that emits array of trending topics
    func getTrendingTopics(limit: Int?) -> AnyPublisher<[TrendingTopic], AppError>
    
    // MARK: - Categories and Sources
    
    /// Fetch all available news categories
    /// - Returns: Publisher that emits array of news categories
    func fetchCategories() -> AnyPublisher<[NewsCategory], AppError>
    
    /// Fetch all available news sources
    /// - Returns: Publisher that emits array of news sources
    func fetchSources() -> AnyPublisher<[NewsSource], AppError>
    
    /// Fetch articles from specific sources
    /// - Parameters:
    ///   - sources: Array of news sources to fetch from
    ///   - page: Page number for pagination
    ///   - limit: Number of articles per page
    /// - Returns: Publisher that emits news response with pagination info
    func fetchArticlesFromSources(
        _ sources: [NewsSource],
        page: Int,
        limit: Int
    ) -> AnyPublisher<NewsResponse, AppError>
    
    // MARK: - User Interactions
    
    /// Get recent articles for user
    /// - Parameter limit: Maximum number of articles to fetch
    /// - Returns: Publisher that emits array of NewsArticle or AppError
    func getRecentArticles(limit: Int) -> AnyPublisher<[NewsArticle], AppError>
    
    /// Get saved articles for user
    /// - Parameter limit: Maximum number of articles to fetch
    /// - Returns: Publisher that emits array of NewsArticle or AppError
    func getSavedArticles(limit: Int) -> AnyPublisher<[NewsArticle], AppError>
    
    /// Like an article
    /// - Parameter articleId: ID of the article to like
    /// - Returns: Publisher that emits success status
    func likeArticle(id articleId: String) -> AnyPublisher<Bool, AppError>
    
    /// Unlike an article
    /// - Parameter articleId: ID of the article to unlike
    /// - Returns: Publisher that emits success status
    func unlikeArticle(id articleId: String) -> AnyPublisher<Bool, AppError>
    
    /// Share an article
    /// - Parameters:
    ///   - articleId: ID of the article to share
    ///   - platform: Sharing platform (optional)
    /// - Returns: Publisher that emits success status
    func shareArticle(
        id articleId: String,
        platform: String?
    ) -> AnyPublisher<Bool, AppError>
    
    /// Track article view for analytics
    /// - Parameter articleId: ID of the article being viewed
    /// - Returns: Publisher that emits success status
    func trackArticleView(id articleId: String) -> AnyPublisher<Bool, AppError>
    
    // MARK: - Bookmarks and Favorites
    
    /// Add article to bookmarks
    /// - Parameter articleId: ID of the article to bookmark
    /// - Returns: Publisher that emits success status
    func bookmarkArticle(id articleId: String) -> AnyPublisher<Bool, AppError>
    
    /// Remove article from bookmarks
    /// - Parameter articleId: ID of the article to unbookmark
    /// - Returns: Publisher that emits success status
    func unbookmarkArticle(id articleId: String) -> AnyPublisher<Bool, AppError>
    
    /// Fetch user's bookmarked articles
    /// - Parameters:
    ///   - page: Page number for pagination
    ///   - limit: Number of articles per page
    /// - Returns: Publisher that emits news response with pagination info
    func fetchBookmarkedArticles(
        page: Int,
        limit: Int
    ) -> AnyPublisher<NewsResponse, AppError>
    
    /// Check if article is bookmarked
    /// - Parameter articleId: ID of the article to check
    /// - Returns: Publisher that emits bookmark status
    func isArticleBookmarked(id articleId: String) -> AnyPublisher<Bool, AppError>
    
    // MARK: - Real-time Updates
    
    /// Subscribe to real-time news updates
    /// - Returns: Publisher that emits new articles as they become available
    func subscribeToNewsUpdates() -> AnyPublisher<NewsArticle, AppError>
    
    /// Subscribe to breaking news notifications
    /// - Returns: Publisher that emits breaking news alerts
    func subscribeToBreakingNews() -> AnyPublisher<BreakingNewsAlert, AppError>
    
    /// Subscribe to category-specific updates
    /// - Parameter category: Category to receive updates for
    /// - Returns: Publisher that emits new articles in the specified category
    func subscribeToCategoryUpdates(
        _ category: NewsCategory
    ) -> AnyPublisher<NewsArticle, AppError>
    
    // MARK: - Offline Support
    
    /// Cache articles for offline reading
    /// - Parameter articles: Articles to cache
    /// - Returns: Publisher that emits success status
    func cacheArticles(_ articles: [NewsArticle]) -> AnyPublisher<Bool, AppError>
    
    /// Fetch cached articles
    /// - Returns: Publisher that emits array of cached articles
    func fetchCachedArticles() -> AnyPublisher<[NewsArticle], AppError>
    
    /// Clear expired cache
    /// - Returns: Publisher that emits success status
    func clearExpiredCache() -> AnyPublisher<Bool, AppError>
    
    // MARK: - Analytics and Insights
    
    /// Get reading statistics for the user
    /// - Returns: Publisher that emits user reading statistics
    func getReadingStatistics() -> AnyPublisher<UserStatistics, AppError>
    
    /// Get trending articles based on user's reading history
    /// - Parameter limit: Maximum number of trending articles
    /// - Returns: Publisher that emits array of personalized trending articles
    func getPersonalizedTrending(limit: Int?) -> AnyPublisher<[NewsArticle], AppError>
    
    /// Get recommended articles based on user preferences
    /// - Parameters:
    ///   - limit: Maximum number of recommended articles
    ///   - excludeRead: Whether to exclude already read articles
    /// - Returns: Publisher that emits array of recommended articles
    func getRecommendedArticles(
        limit: Int?,
        excludeRead: Bool
    ) -> AnyPublisher<[NewsArticle], AppError>
}

// MARK: - Async/Await Support

/// Extension providing async/await support for NewsServiceProtocol
@available(iOS 13.0, *)
extension NewsServiceProtocol {
    
    // MARK: - News Fetching (Async)
    
    /// Fetch top headlines with optional category filter (Async)
    func fetchTopHeadlines(category: NewsCategory? = nil) async throws -> [NewsArticle] {
        try await withCheckedThrowingContinuation { continuation in
            let cancellable = fetchTopHeadlines(category: category)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { articles in
                        continuation.resume(returning: articles)
                    }
                )
            // Store the cancellable to prevent deallocation
            _ = cancellable
        }
    }
    
    /// Fetch breaking news articles (Async)
    func fetchBreakingNews() async throws -> [NewsArticle] {
        try await withCheckedThrowingContinuation { continuation in
            let cancellable = fetchBreakingNews()
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { articles in
                        continuation.resume(returning: articles)
                    }
                )
            _ = cancellable
        }
    }
    
    /// Fetch trending news articles (Async)
    func fetchTrendingNews(limit: Int? = nil) async throws -> [NewsArticle] {
        try await withCheckedThrowingContinuation { continuation in
            let cancellable = fetchTrendingNews(limit: limit)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { articles in
                        continuation.resume(returning: articles)
                    }
                )
            _ = cancellable
        }
    }
    
    /// Get a specific article by ID (Async)
    func getArticle(id: String) async throws -> NewsArticle {
        try await withCheckedThrowingContinuation { continuation in
            let cancellable = getArticle(id: id)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { article in
                        continuation.resume(returning: article)
                    }
                )
            _ = cancellable
        }
    }
    
    /// Search articles with query and optional filters (Async)
    func searchArticles(
        query: String,
        filters: SearchFilters? = nil,
        page: Int = 1,
        limit: Int = 20
    ) async throws -> NewsResponse {
        try await withCheckedThrowingContinuation { continuation in
            let cancellable = searchArticles(query: query, filters: filters, page: page, limit: limit)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { response in
                        continuation.resume(returning: response)
                    }
                )
            _ = cancellable
        }
    }
    
    /// Like an article (Async)
    func likeArticle(id articleId: String) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            let cancellable = likeArticle(id: articleId)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { success in
                        continuation.resume(returning: success)
                    }
                )
            _ = cancellable
        }
    }
    
    /// Share an article (Async)
    func shareArticle(id articleId: String, platform: String? = nil) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            let cancellable = shareArticle(id: articleId, platform: platform)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { success in
                        continuation.resume(returning: success)
                    }
                )
            _ = cancellable
        }
    }
    
    /// Track article view for analytics (Async)
    func trackArticleView(id articleId: String) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            let cancellable = trackArticleView(id: articleId)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { success in
                        continuation.resume(returning: success)
                    }
                )
            _ = cancellable
        }
    }
    
    /// Fetch categories (Async)
    func fetchCategories() async throws -> [NewsCategory] {
        try await withCheckedThrowingContinuation { continuation in
            let cancellable = fetchCategories()
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { categories in
                        continuation.resume(returning: categories)
                    }
                )
            _ = cancellable
        }
    }
    
    /// Fetch sources (Async)
    func fetchSources() async throws -> [NewsSource] {
        try await withCheckedThrowingContinuation { continuation in
            let cancellable = fetchSources()
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { sources in
                        continuation.resume(returning: sources)
                    }
                )
            _ = cancellable
        }
    }
}
