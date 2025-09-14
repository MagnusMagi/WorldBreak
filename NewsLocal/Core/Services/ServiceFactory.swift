import Foundation

// MARK: - Service Factory

/// Factory for creating news service instances
struct ServiceFactory {
    
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
