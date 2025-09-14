import Foundation

/// API endpoints configuration for NewsLocal
struct APIEndpoints {
    
    // MARK: - Base Configuration
    static let baseURL = "http://localhost:3000/api/v1"
    static let timeout: TimeInterval = 30.0
    
    // MARK: - News Endpoints
    struct News {
        static let topHeadlines = "\(baseURL)/news/headlines"
        static let category = "\(baseURL)/news/category"
        static let search = "\(baseURL)/news/search"
        static let breaking = "\(baseURL)/news/breaking"
        static let trending = "\(baseURL)/news/trending"
        static let recommended = "\(baseURL)/news/recommended"
        static let detail = "\(baseURL)/news/detail"
    }
    
    // MARK: - User Endpoints
    struct User {
        static let preferences = "\(baseURL)/user/preferences"
        static let readingHistory = "\(baseURL)/user/history"
        static let bookmarks = "\(baseURL)/user/bookmarks"
        static let notifications = "\(baseURL)/user/notifications"
    }
    
    // MARK: - Authentication Endpoints
    struct Auth {
        static let login = "\(baseURL)/auth/login"
        static let register = "\(baseURL)/auth/register"
        static let logout = "\(baseURL)/auth/logout"
        static let refresh = "\(baseURL)/auth/refresh"
        static let profile = "\(baseURL)/auth/profile"
    }
    
    // MARK: - Content Endpoints
    struct Content {
        static let categories = "\(baseURL)/content/categories"
        static let sources = "\(baseURL)/content/sources"
        static let tags = "\(baseURL)/content/tags"
    }
    
    // MARK: - Utility Methods
    
    /// Builds URL with query parameters
    static func buildURL(_ endpoint: String, parameters: [String: String] = [:]) -> URL? {
        guard var urlComponents = URLComponents(string: endpoint) else { return nil }
        
        if !parameters.isEmpty {
            urlComponents.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        
        return urlComponents.url
    }
    
    /// Builds URL with path parameters
    static func buildURL(_ endpoint: String, pathParameters: [String: String] = [:]) -> String {
        var url = endpoint
        
        for (key, value) in pathParameters {
            url = url.replacingOccurrences(of: "{\(key)}", with: value)
        }
        
        return url
    }
}
