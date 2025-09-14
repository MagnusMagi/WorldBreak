import Foundation
import Combine

/// Mock implementation of NewsServiceProtocol for development
class MockNewsService: NewsServiceProtocol {
    
    private let mockArticles: [NewsArticle]
    private let mockCategories: [NewsCategory]
    private let mockSources: [NewsSource]
    private let mockTrendingTopics: [TrendingTopic]
    
    init(
        mockArticles: [NewsArticle] = MockDataGenerator.generateMockArticles(count: 100),
        mockCategories: [NewsCategory] = NewsCategory.allCases,
        mockSources: [NewsSource] = [],
        mockTrendingTopics: [TrendingTopic] = []
    ) {
        self.mockArticles = mockArticles
        self.mockCategories = mockCategories
        self.mockSources = mockSources
        self.mockTrendingTopics = mockTrendingTopics
    }
    
    // MARK: - News Fetching
    
    func fetchTopHeadlines(category: NewsCategory?) -> AnyPublisher<[NewsArticle], AppError> {
        let filteredArticles = category == nil ? 
            mockArticles : 
            mockArticles.filter { $0.category.id == category!.id }
        
        return Just(filteredArticles.prefix(10).map { $0 })
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchBreakingNews() -> AnyPublisher<[NewsArticle], AppError> {
        // Mock breaking news as first 3 articles
        let breakingArticles = Array(mockArticles.prefix(3))
        return Just(breakingArticles)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchTrendingNews(limit: Int?) -> AnyPublisher<[NewsArticle], AppError> {
        // Mock trending news as articles 4-10
        let trendingArticles = Array(mockArticles.dropFirst(3).prefix(7))
        let limitedArticles = limit != nil ? 
            Array(trendingArticles.prefix(limit!)) : 
            trendingArticles
        
        return Just(limitedArticles)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchArticlesByCategory(
        _ category: NewsCategory,
        page: Int,
        limit: Int
    ) -> AnyPublisher<NewsResponse, AppError> {
        let filteredArticles = mockArticles.filter { $0.category.id == category.id }
        let startIndex = (page - 1) * limit
        let endIndex = min(startIndex + limit, filteredArticles.count)
        let pageArticles = Array(filteredArticles[startIndex..<endIndex])
        
        let response = NewsResponse(
            articles: pageArticles,
            totalResults: filteredArticles.count,
            page: page,
            pageSize: limit,
            hasMore: endIndex < filteredArticles.count
        )
        
        return Just(response)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getArticle(id: String) -> AnyPublisher<NewsArticle, AppError> {
        guard let article = mockArticles.first(where: { $0.id == id }) else {
            return Fail(error: AppError.network(.notFound("Article with id \(id) not found")))
                .eraseToAnyPublisher()
        }
        
        return Just(article)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchRelatedArticles(
        for article: NewsArticle,
        limit: Int
    ) -> AnyPublisher<[NewsArticle], AppError> {
        let relatedArticles = mockArticles
            .filter { $0.id != article.id && $0.category.id == article.category.id }
            .prefix(limit)
            .map { $0 }
        
        return Just(Array(relatedArticles))
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.4), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Search Operations
    
    func searchArticles(
        query: String,
        filters: SearchFilters?,
        page: Int,
        limit: Int
    ) -> AnyPublisher<NewsResponse, AppError> {
        var filteredArticles = mockArticles.filter { article in
            article.title.localizedCaseInsensitiveContains(query) ||
            article.content.localizedCaseInsensitiveContains(query) ||
            article.summary.localizedCaseInsensitiveContains(query)
        }
        
        // Apply additional filters
        if let filters = filters {
            if let categories = filters.categories, !categories.isEmpty {
                filteredArticles = filteredArticles.filter { article in
                    categories.contains { $0.id == article.category.id }
                }
            }
            
            if let sources = filters.sources, !sources.isEmpty {
                filteredArticles = filteredArticles.filter { article in
                    sources.contains { $0.name == article.source.name }
                }
            }
        }
        
        let startIndex = (page - 1) * limit
        let endIndex = min(startIndex + limit, filteredArticles.count)
        let pageArticles = Array(filteredArticles[startIndex..<endIndex])
        
        let response = NewsResponse(
            articles: pageArticles,
            totalResults: filteredArticles.count,
            page: page,
            pageSize: limit,
            hasMore: endIndex < filteredArticles.count
        )
        
        return Just(response)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.4), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getSearchSuggestions(query: String) -> AnyPublisher<[String], AppError> {
        let suggestions = [
            "artificial intelligence",
            "climate change",
            "technology news",
            "business updates",
            "science discoveries"
        ].filter { $0.localizedCaseInsensitiveContains(query) }
        
        return Just(suggestions)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getTrendingTopics(limit: Int?) -> AnyPublisher<[TrendingTopic], AppError> {
        let limitedTopics = limit != nil ? 
            Array(mockTrendingTopics.prefix(limit!)) : 
            mockTrendingTopics
        
        return Just(limitedTopics)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Categories and Sources
    
    func fetchCategories() -> AnyPublisher<[NewsCategory], AppError> {
        return Just(mockCategories)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchSources() -> AnyPublisher<[NewsSource], AppError> {
        return Just(mockSources)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchArticlesFromSources(
        _ sources: [NewsSource],
        page: Int,
        limit: Int
    ) -> AnyPublisher<NewsResponse, AppError> {
        let sourceNames = sources.map { $0.name }
        let filteredArticles = mockArticles.filter { sourceNames.contains($0.source.name) }
        
        let startIndex = (page - 1) * limit
        let endIndex = min(startIndex + limit, filteredArticles.count)
        let pageArticles = Array(filteredArticles[startIndex..<endIndex])
        
        let response = NewsResponse(
            articles: pageArticles,
            totalResults: filteredArticles.count,
            page: page,
            pageSize: limit,
            hasMore: endIndex < filteredArticles.count
        )
        
        return Just(response)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - User Interactions
    
    func getRecentArticles(limit: Int) -> AnyPublisher<[NewsArticle], AppError> {
        let recentArticles = Array(mockArticles.prefix(limit))
        return Just(recentArticles)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getSavedArticles(limit: Int) -> AnyPublisher<[NewsArticle], AppError> {
        let savedArticles = Array(mockArticles.prefix(limit))
        return Just(savedArticles)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func likeArticle(id articleId: String) -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func unlikeArticle(id articleId: String) -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func shareArticle(id articleId: String, platform: String?) -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func trackArticleView(id articleId: String) -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Bookmarks and Favorites
    
    func bookmarkArticle(id articleId: String) -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func unbookmarkArticle(id articleId: String) -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchBookmarkedArticles(page: Int, limit: Int) -> AnyPublisher<NewsResponse, AppError> {
        let response = NewsResponse(
            articles: [],
            totalResults: 0,
            page: page,
            pageSize: limit,
            hasMore: false
        )
        return Just(response)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func isArticleBookmarked(id articleId: String) -> AnyPublisher<Bool, AppError> {
        return Just(false)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Real-time Updates
    
    func subscribeToNewsUpdates() -> AnyPublisher<NewsArticle, AppError> {
        return Empty<NewsArticle, AppError>()
            .eraseToAnyPublisher()
    }
    
    func subscribeToBreakingNews() -> AnyPublisher<BreakingNewsAlert, AppError> {
        return Empty<BreakingNewsAlert, AppError>()
            .eraseToAnyPublisher()
    }
    
    func subscribeToCategoryUpdates(_ category: NewsCategory) -> AnyPublisher<NewsArticle, AppError> {
        return Empty<NewsArticle, AppError>()
            .eraseToAnyPublisher()
    }
    
    // MARK: - Offline Support
    
    func cacheArticles(_ articles: [NewsArticle]) -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchCachedArticles() -> AnyPublisher<[NewsArticle], AppError> {
        return Just([])
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func clearExpiredCache() -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Analytics and Insights
    
    func getReadingStatistics() -> AnyPublisher<UserStatistics, AppError> {
        let statistics = UserStatistics(
            articlesRead: 150,
            articlesLiked: 45,
            articlesShared: 12,
            searchQueries: 89,
            timeSpentReading: 7200,
            favoriteCategories: ["technology": 45, "science": 32],
            favoriteSources: ["TechNews": 25, "ScienceDaily": 20],
            readingStreak: 7
        )
        return Just(statistics)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getPersonalizedTrending(limit: Int?) -> AnyPublisher<[NewsArticle], AppError> {
        let trendingArticles = Array(mockArticles.dropFirst(3).prefix(7))
        let limitedArticles = limit != nil ? 
            Array(trendingArticles.prefix(limit!)) : 
            trendingArticles
        
        return Just(limitedArticles)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getRecommendedArticles(limit: Int?, excludeRead: Bool) -> AnyPublisher<[NewsArticle], AppError> {
        let recommendedArticles = Array(mockArticles.dropFirst(10).prefix(5))
        let limitedArticles = limit != nil ? 
            Array(recommendedArticles.prefix(limit!)) : 
            recommendedArticles
        
        return Just(limitedArticles)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
