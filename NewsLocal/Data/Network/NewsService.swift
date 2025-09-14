import Foundation
import Combine

/// Network implementation of NewsServiceProtocol
class NewsService: NewsServiceProtocol {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: - News Fetching
    
    func fetchTopHeadlines(category: NewsCategory? = nil) -> AnyPublisher<[NewsArticle], AppError> {
        var parameters: [String: String] = ["pageSize": "20"]
        if let category = category {
            parameters["category"] = category.id // Use .id instead of .rawValue
        }

        guard let url = APIEndpoints.buildURL(APIEndpoints.News.topHeadlines, parameters: parameters) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        
        return networkManager.request(NewsResponse.self, from: url)
            .map { $0.articles }
            .eraseToAnyPublisher()
    }
    
    func fetchBreakingNews() -> AnyPublisher<[NewsArticle], AppError> {
        guard let url = URL(string: APIEndpoints.News.breaking) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        
        return networkManager.request(BreakingNewsResponse.self, from: url)
            .map { $0.articles }
            .eraseToAnyPublisher()
    }
    
    func fetchTrendingNews(limit: Int?) -> AnyPublisher<[NewsArticle], AppError> {
        var parameters: [String: String] = [:]
        if let limit = limit {
            parameters["limit"] = String(limit)
        }
        
        guard let url = APIEndpoints.buildURL(APIEndpoints.News.trending, parameters: parameters) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        
        return networkManager.request(TrendingNewsResponse.self, from: url)
            .map { $0.articles }
            .eraseToAnyPublisher()
    }
    
    func fetchArticlesByCategory(_ category: NewsCategory, page: Int, limit: Int) -> AnyPublisher<NewsResponse, AppError> {
        let parameters = [
            "category": category.id, // Use .id instead of .rawValue
            "page": String(page),
            "pageSize": String(limit)
        ]
        
        guard let url = APIEndpoints.buildURL(APIEndpoints.News.category, parameters: parameters) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        
        return networkManager.request(NewsResponse.self, from: url)
            .eraseToAnyPublisher()
    }
    
    func getArticle(id: String) -> AnyPublisher<NewsArticle, AppError> {
        let endpoint = APIEndpoints.buildURL(APIEndpoints.News.detail, pathParameters: ["id": id])
        
        guard let url = URL(string: endpoint) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        
        return networkManager.request(NewsArticle.self, from: url)
            .eraseToAnyPublisher()
    }
    
    func fetchRelatedArticles(for article: NewsArticle, limit: Int) -> AnyPublisher<[NewsArticle], AppError> {
        let parameters = [
            "articleId": article.id,
            "limit": String(limit)
        ]
        
        guard let url = APIEndpoints.buildURL(APIEndpoints.News.recommended, parameters: parameters) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        
        return networkManager.request(RecommendedNewsResponse.self, from: url)
            .map { $0.articles }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Search Operations
    
    func searchArticles(query: String, filters: SearchFilters? = nil, page: Int, limit: Int) -> AnyPublisher<NewsResponse, AppError> {
        var parameters: [String: String] = [
            "q": query,
            "page": String(page),
            "pageSize": String(limit)
        ]
        
        if let filters = filters {
            if let categories = filters.categories, !categories.isEmpty {
                parameters["categories"] = categories.map { $0.id }.joined(separator: ",")
            }
            if let sources = filters.sources, !sources.isEmpty {
                parameters["sources"] = sources.map { $0.name }.joined(separator: ",")
            }
        }
        
        guard let url = APIEndpoints.buildURL(APIEndpoints.News.search, parameters: parameters) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        
        return networkManager.request(NewsResponse.self, from: url)
            .eraseToAnyPublisher()
    }
    
    func getSearchSuggestions(query: String) -> AnyPublisher<[String], AppError> {
        let parameters = ["q": query]
        guard let url = APIEndpoints.buildURL(APIEndpoints.Content.tags, parameters: parameters) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        
        return networkManager.request([String].self, from: url)
            .eraseToAnyPublisher()
    }
    
    func getTrendingTopics(limit: Int? = nil) -> AnyPublisher<[TrendingTopic], AppError> {
        var parameters: [String: String] = [:]
        if let limit = limit {
            parameters["limit"] = String(limit)
        }
        guard let url = APIEndpoints.buildURL(APIEndpoints.Content.tags, parameters: parameters) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        
        return networkManager.request([TrendingTopic].self, from: url)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Categories and Sources
    
    func fetchCategories() -> AnyPublisher<[NewsCategory], AppError> {
        guard let url = URL(string: APIEndpoints.Content.categories) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        return networkManager.request([NewsCategory].self, from: url)
            .eraseToAnyPublisher()
    }
    
    func fetchSources() -> AnyPublisher<[NewsSource], AppError> {
        guard let url = URL(string: APIEndpoints.Content.sources) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        return networkManager.request([NewsSource].self, from: url)
            .eraseToAnyPublisher()
    }
    
    func fetchArticlesFromSources(_ sources: [NewsSource], page: Int, limit: Int) -> AnyPublisher<NewsResponse, AppError> {
        let sourceIds = sources.map { $0.id }.joined(separator: ",")
        let parameters = [
            "sourceIds": sourceIds,
            "page": String(page),
            "pageSize": String(limit)
        ]
        guard let url = APIEndpoints.buildURL(APIEndpoints.News.search, parameters: parameters) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        return networkManager.request(NewsResponse.self, from: url)
            .eraseToAnyPublisher()
    }
    
    // MARK: - User Interactions
    
    func likeArticle(id articleId: String) -> AnyPublisher<Bool, AppError> {
        guard let url = URL(string: APIEndpoints.News.detail + "/\(articleId)/like") else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        
        return networkManager.request(Bool.self, from: url, method: .post) // Assume request method is available
            .eraseToAnyPublisher()
    }
    
    func unlikeArticle(id articleId: String) -> AnyPublisher<Bool, AppError> {
        guard let url = URL(string: APIEndpoints.News.detail + "/\(articleId)/unlike") else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        
        return networkManager.request(Bool.self, from: url, method: .post) // Assume request method is available
            .eraseToAnyPublisher()
    }
    
    func shareArticle(id articleId: String, platform: String?) -> AnyPublisher<Bool, AppError> {
        var parameters: [String: String] = [:]
        if let platform = platform {
            parameters["platform"] = platform
        }
        guard let url = APIEndpoints.buildURL(APIEndpoints.News.detail + "/\(articleId)/share", parameters: parameters) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        
        return networkManager.request(Bool.self, from: url, method: .post) // Assume request method is available
            .eraseToAnyPublisher()
    }
    
    func trackArticleView(id articleId: String) -> AnyPublisher<Bool, AppError> {
        guard let url = URL(string: APIEndpoints.User.readingHistory + "/track") else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        
        let bodyData = try? JSONSerialization.data(withJSONObject: ["articleId": articleId])
        return networkManager.request(Bool.self, from: url, method: .post, body: bodyData)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Bookmarks and Favorites
    
    func bookmarkArticle(id articleId: String) -> AnyPublisher<Bool, AppError> {
        guard let url = URL(string: APIEndpoints.User.bookmarks + "/\(articleId)") else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        return networkManager.request(Bool.self, from: url, method: .post) // Assume request method is available
            .eraseToAnyPublisher()
    }
    
    func unbookmarkArticle(id articleId: String) -> AnyPublisher<Bool, AppError> {
        guard let url = URL(string: APIEndpoints.User.bookmarks + "/\(articleId)") else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        return networkManager.request(Bool.self, from: url, method: .delete) // Assume request method is available
            .eraseToAnyPublisher()
    }
    
    func fetchBookmarkedArticles(page: Int, limit: Int) -> AnyPublisher<NewsResponse, AppError> {
        let parameters = [
            "page": String(page),
            "pageSize": String(limit)
        ]
        guard let url = APIEndpoints.buildURL(APIEndpoints.User.bookmarks, parameters: parameters) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        return networkManager.request(NewsResponse.self, from: url)
            .eraseToAnyPublisher()
    }
    
    func isArticleBookmarked(id articleId: String) -> AnyPublisher<Bool, AppError> {
        guard let url = URL(string: APIEndpoints.User.bookmarks + "/\(articleId)/status") else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        return networkManager.request(Bool.self, from: url)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Real-time Updates
    
    func subscribeToNewsUpdates() -> AnyPublisher<NewsArticle, AppError> {
        // This would typically involve WebSocket connection
        return Empty<NewsArticle, AppError>()
            .eraseToAnyPublisher()
    }
    
    func subscribeToBreakingNews() -> AnyPublisher<BreakingNewsAlert, AppError> {
        // This would typically involve WebSocket connection
        return Empty<BreakingNewsAlert, AppError>()
            .eraseToAnyPublisher()
    }
    
    func subscribeToCategoryUpdates(_ category: NewsCategory) -> AnyPublisher<NewsArticle, AppError> {
        // This would typically involve WebSocket connection
        return Empty<NewsArticle, AppError>()
            .eraseToAnyPublisher()
    }
    
    // MARK: - Offline Support
    
    func cacheArticles(_ articles: [NewsArticle]) -> AnyPublisher<Bool, AppError> {
        // This would involve Core Data or local storage
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchCachedArticles() -> AnyPublisher<[NewsArticle], AppError> {
        // This would involve Core Data or local storage
        return Just([])
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func clearExpiredCache() -> AnyPublisher<Bool, AppError> {
        // This would involve Core Data or local storage
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Analytics and Insights
    
    func getReadingStatistics() -> AnyPublisher<UserStatistics, AppError> {
        guard let url = URL(string: APIEndpoints.User.readingHistory + "/statistics") else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        return networkManager.request(UserStatistics.self, from: url)
            .eraseToAnyPublisher()
    }
    
    func getPersonalizedTrending(limit: Int?) -> AnyPublisher<[NewsArticle], AppError> {
        var parameters: [String: String] = [:]
        if let limit = limit {
            parameters["limit"] = String(limit)
        }
        guard let url = APIEndpoints.buildURL(APIEndpoints.News.trending, parameters: parameters) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        return networkManager.request(TrendingNewsResponse.self, from: url)
            .map { $0.articles }
            .eraseToAnyPublisher()
    }
    
    func getRecommendedArticles(limit: Int?, excludeRead: Bool) -> AnyPublisher<[NewsArticle], AppError> {
        var parameters: [String: String] = ["excludeRead": String(excludeRead)]
        if let limit = limit {
            parameters["limit"] = String(limit)
        }
        guard let url = APIEndpoints.buildURL(APIEndpoints.News.recommended, parameters: parameters) else {
            return Fail(error: AppError.network(.invalidURL))
                .eraseToAnyPublisher()
        }
        return networkManager.request(RecommendedNewsResponse.self, from: url)
            .map { $0.articles }
            .eraseToAnyPublisher()
    }
}

// MARK: - Response Models

private struct BreakingNewsResponse: Codable {
    let articles: [NewsArticle]
}

private struct TrendingNewsResponse: Codable {
    let articles: [NewsArticle]
}

private struct RecommendedNewsResponse: Codable {
    let articles: [NewsArticle]
}
