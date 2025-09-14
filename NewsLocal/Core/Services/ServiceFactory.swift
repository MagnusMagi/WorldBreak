import Foundation

// MARK: - Service Factory

/// Factory for creating news service instances
struct ServiceFactory {
    
    /// Shared instance for dependency injection
    static let shared = ServiceFactory()
    
    /// News service instance
    let newsService: NewsServiceProtocol
    
    private init() {
        self.newsService = Self.createNewsService()
    }
    
    /// Create a news service instance
    /// - Parameter isMock: Whether to create a mock service or a real service
    /// - Returns: News service conforming to NewsServiceProtocol
    static func createNewsService(isMock: Bool = true) -> NewsServiceProtocol {
        if isMock {
            return MockNewsService()
        } else {
            return NewsService()
        }
    }
}
