//
//  NewsModels.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation

// MARK: - News Article Model

/// Represents a news article with comprehensive metadata
struct NewsArticle: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let content: String
    let summary: String
    let author: String
    let source: NewsSource
    let publishedAt: Date
    let category: NewsCategory
    let imageUrl: URL?
    let articleUrl: URL
    let isBreaking: Bool
    let tags: [String]
    let likeCount: Int
    let shareCount: Int
    
    // MARK: - Computed Properties
    
    /// Estimated reading time in minutes based on content length
    var readingTime: Int {
        let wordsPerMinute = 200
        let wordCount = content.components(separatedBy: .whitespacesAndNewlines).count
        return max(1, wordCount / wordsPerMinute)
    }
    
    /// Human-readable time ago string
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: publishedAt, relativeTo: Date())
    }
    
    /// Formatted date string for display
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: publishedAt)
    }
    
    /// Shortened content for preview
    var previewContent: String {
        let maxLength = 150
        if content.count <= maxLength {
            return content
        }
        let index = content.index(content.startIndex, offsetBy: maxLength)
        return String(content[..<index]) + "..."
    }
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, summary, author, source, category, tags, likeCount, shareCount
        case publishedAt = "published_at"
        case imageUrl = "image_url"
        case articleUrl = "article_url"
        case isBreaking = "is_breaking"
    }
    
    // MARK: - Initializers
    
    init(
        id: String = UUID().uuidString,
        title: String,
        content: String,
        summary: String,
        author: String,
        source: NewsSource,
        publishedAt: Date = Date(),
        category: NewsCategory,
        imageUrl: URL? = nil,
        articleUrl: URL,
        isBreaking: Bool = false,
        tags: [String] = [],
        likeCount: Int = 0,
        shareCount: Int = 0
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.summary = summary
        self.author = author
        self.source = source
        self.publishedAt = publishedAt
        self.category = category
        self.imageUrl = imageUrl
        self.articleUrl = articleUrl
        self.isBreaking = isBreaking
        self.tags = tags
        self.likeCount = likeCount
        self.shareCount = shareCount
    }
}

// MARK: - News Category Model

/// Represents a news category with display information
struct NewsCategory: Identifiable, Codable, Equatable, Hashable, CaseIterable {
    let id: String
    let name: String
    let displayName: String
    let icon: String
    let color: String
    
    // MARK: - Static Categories
    
    static let allCases: [NewsCategory] = [
        .general,
        .business,
        .technology,
        .science,
        .health,
        .sports,
        .entertainment,
        .politics,
        .world,
        .local
    ]
    
    static let general = NewsCategory(
        id: "general",
        name: "general",
        displayName: "General",
        icon: "newspaper",
        color: "gray"
    )
    
    static let business = NewsCategory(
        id: "business",
        name: "business",
        displayName: "Business",
        icon: "briefcase",
        color: "blue"
    )
    
    static let technology = NewsCategory(
        id: "technology",
        name: "technology",
        displayName: "Technology",
        icon: "laptopcomputer",
        color: "purple"
    )
    
    static let science = NewsCategory(
        id: "science",
        name: "science",
        displayName: "Science",
        icon: "atom",
        color: "green"
    )
    
    static let health = NewsCategory(
        id: "health",
        name: "health",
        displayName: "Health",
        icon: "heart",
        color: "red"
    )
    
    static let sports = NewsCategory(
        id: "sports",
        name: "sports",
        displayName: "Sports",
        icon: "sportscourt",
        color: "orange"
    )
    
    static let entertainment = NewsCategory(
        id: "entertainment",
        name: "entertainment",
        displayName: "Entertainment",
        icon: "tv",
        color: "pink"
    )
    
    static let politics = NewsCategory(
        id: "politics",
        name: "politics",
        displayName: "Politics",
        icon: "building.2",
        color: "indigo"
    )
    
    static let world = NewsCategory(
        id: "world",
        name: "world",
        displayName: "World",
        icon: "globe",
        color: "teal"
    )
    
    static let local = NewsCategory(
        id: "local",
        name: "local",
        displayName: "Local",
        icon: "location",
        color: "mint"
    )
    
    // MARK: - Helper Methods
    
    /// Get category by ID
    static func category(with id: String) -> NewsCategory? {
        return allCases.first { $0.id == id }
    }
    
    /// Get category by name
    static func category(withName name: String) -> NewsCategory? {
        return allCases.first { $0.name == name }
    }
}

// MARK: - News Source Model

/// Represents a news source with credibility information
struct NewsSource: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let description: String
    let url: URL
    let logoUrl: URL?
    let credibilityScore: Double
    let isVerified: Bool
    let country: String
    let language: String
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, url, country, language
        case logoUrl = "logo_url"
        case credibilityScore = "credibility_score"
        case isVerified = "is_verified"
    }
    
    // MARK: - Initializers
    
    init(
        id: String = UUID().uuidString,
        name: String,
        description: String = "A general news source.", // Added default description
        url: URL = URL(string: "https://example.com")!, // Added default URL
        logoUrl: URL? = nil,
        credibilityScore: Double = 0.0,
        isVerified: Bool = false,
        country: String = "US",
        language: String = "en"
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.url = url
        self.logoUrl = logoUrl
        self.credibilityScore = credibilityScore
        self.isVerified = isVerified
        self.country = country
        self.language = language
    }
}

// MARK: - News Response Model

/// Response wrapper for news API calls
struct NewsResponse: Codable {
    let articles: [NewsArticle]
    let totalResults: Int
    let page: Int
    let pageSize: Int
    let hasMore: Bool
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case articles
        case totalResults = "total_results"
        case page
        case pageSize = "page_size"
        case hasMore = "has_more"
    }
    
    // MARK: - Computed Properties
    
    /// Total number of pages
    var totalPages: Int {
        return Int(ceil(Double(totalResults) / Double(pageSize)))
    }
    
    /// Whether this is the last page
    var isLastPage: Bool {
        return page >= totalPages
    }
    
    // MARK: - Initializers
    
    init(
        articles: [NewsArticle],
        totalResults: Int,
        page: Int = 1,
        pageSize: Int = 20,
        hasMore: Bool = false
    ) {
        self.articles = articles
        self.totalResults = totalResults
        self.page = page
        self.pageSize = pageSize
        self.hasMore = hasMore
    }
}

// MARK: - Search Filters Model

/// Filters for news search functionality
struct SearchFilters: Codable, Equatable {
    let categories: [NewsCategory]?
    let sources: [NewsSource]?
    let dateFrom: Date?
    let dateTo: Date?
    let language: String?
    let country: String?
    let sortBy: SortOption?
    let sortOrder: SortOrder?
    
    // MARK: - Sort Options
    
    enum SortOption: String, Codable, CaseIterable, Identifiable {
        case publishedAt = "published_at"
        case relevance = "relevance"
        case popularity = "popularity"
        case viewCount = "view_count"
        case likeCount = "like_count"
        
        var id: String { rawValue }
        
        var displayName: String {
            switch self {
            case .publishedAt: return "Published Date"
            case .relevance: return "Relevance"
            case .popularity: return "Popularity"
            case .viewCount: return "View Count"
            case .likeCount: return "Like Count"
            }
        }
    }
    
    enum SortOrder: String, Codable, CaseIterable {
        case ascending = "asc"
        case descending = "desc"
        
        var displayName: String {
            switch self {
            case .ascending: return "Ascending"
            case .descending: return "Descending"
            }
        }
    }
    
    // MARK: - Initializers
    
    init(
        categories: [NewsCategory]? = nil,
        sources: [NewsSource]? = nil,
        dateFrom: Date? = nil,
        dateTo: Date? = nil,
        language: String? = nil,
        country: String? = nil,
        sortBy: SortOption? = nil,
        sortOrder: SortOrder? = nil
    ) {
        self.categories = categories
        self.sources = sources
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.language = language
        self.country = country
        self.sortBy = sortBy
        self.sortOrder = sortOrder
    }
    
    // MARK: - Helper Methods
    
    /// Check if filters are empty
    var isEmpty: Bool {
        return categories?.isEmpty != false &&
               sources?.isEmpty != false &&
               dateFrom == nil &&
               dateTo == nil &&
               language == nil &&
               country == nil &&
               sortBy == nil &&
               sortOrder == nil
    }
    
    /// Get active filter count
    var activeFilterCount: Int {
        var count = 0
        if let categories = categories, !categories.isEmpty { count += 1 }
        if let sources = sources, !sources.isEmpty { count += 1 }
        if dateFrom != nil { count += 1 }
        if dateTo != nil { count += 1 }
        if language != nil { count += 1 }
        if country != nil { count += 1 }
        if sortBy != nil { count += 1 }
        return count
    }
}

// MARK: - Trending Topic Model

/// Represents a trending topic with popularity metrics
struct TrendingTopic: Identifiable, Codable, Equatable {
    let id: String
    let topic: String
    let category: NewsCategory?
    let popularity: Double
    let growth: Double
    let articleCount: Int
    let lastUpdated: Date
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id, topic, category, popularity, growth
        case articleCount = "article_count"
        case lastUpdated = "last_updated"
    }
    
    // MARK: - Initializers
    
    init(
        id: String = UUID().uuidString,
        topic: String,
        category: NewsCategory? = nil,
        popularity: Double,
        growth: Double,
        articleCount: Int,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.topic = topic
        self.category = category
        self.popularity = popularity
        self.growth = growth
        self.articleCount = articleCount
        self.lastUpdated = lastUpdated
    }
}

// MARK: - Breaking News Alert Model

/// Represents a breaking news alert
struct BreakingNewsAlert: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let message: String
    let articleId: String?
    let category: NewsCategory
    let priority: Priority
    let timestamp: Date
    let isRead: Bool
    
    // MARK: - Priority Levels
    
    enum Priority: String, Codable, CaseIterable {
        case low = "low"
        case medium = "medium"
        case high = "high"
        case critical = "critical"
        
        var displayName: String {
            switch self {
            case .low: return "Low"
            case .medium: return "Medium"
            case .high: return "High"
            case .critical: return "Critical"
            }
        }
        
        var color: String {
            switch self {
            case .low: return "green"
            case .medium: return "yellow"
            case .high: return "orange"
            case .critical: return "red"
            }
        }
    }
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id, title, message, category, priority, timestamp
        case articleId = "article_id"
        case isRead = "is_read"
    }
    
    // MARK: - Initializers
    
    init(
        id: String = UUID().uuidString,
        title: String,
        message: String,
        articleId: String? = nil,
        category: NewsCategory,
        priority: Priority = .medium,
        timestamp: Date = Date(),
        isRead: Bool = false
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.articleId = articleId
        self.category = category
        self.priority = priority
        self.timestamp = timestamp
        self.isRead = isRead
    }
}

// MARK: - Extensions

extension NewsArticle {
    /// Mock article for testing and previews
    static let mock = NewsArticle(
        id: "mock-article-1",
        title: "Revolutionary AI Technology Transforms Healthcare Industry",
        content: """
        In a groundbreaking development that could reshape the future of medicine, researchers have unveiled a new artificial intelligence system capable of diagnosing diseases with unprecedented accuracy. The technology, developed by a team of scientists at leading medical institutions, represents a significant leap forward in healthcare innovation.
        
        The AI system, known as MediAI Pro, has been trained on millions of medical images and patient records, enabling it to identify patterns and anomalies that might escape human detection. Early clinical trials have shown remarkable results, with the system achieving 98% accuracy in diagnosing various conditions.
        
        Dr. Sarah Johnson, lead researcher on the project, explained that the technology works by analyzing complex medical data and providing real-time diagnostic insights. "This is not about replacing doctors," she emphasized, "but about augmenting their capabilities and helping them make more informed decisions."
        
        The implications of this breakthrough extend far beyond diagnosis. The system can also predict potential health issues before they become critical, enabling preventive care strategies that could save countless lives. Healthcare providers are already exploring ways to integrate this technology into their existing workflows.
        
        However, the introduction of such advanced AI in healthcare also raises important questions about privacy, ethics, and the future role of medical professionals. Experts are calling for careful consideration of these implications as the technology moves toward widespread adoption.
        
        The research team plans to continue refining the system and conducting larger-scale trials. They hope to see the technology approved for clinical use within the next two years, potentially revolutionizing how we approach healthcare and disease prevention.
        """,
        summary: "New AI system achieves 98% accuracy in disease diagnosis, promising to revolutionize healthcare with predictive capabilities.",
        author: "Dr. Sarah Johnson",
        source: NewsSource(id: "medical_news_today", name: "Medical News Today", description: "Leading medical news and research.", url: URL(string: "https://medicalnewstoday.com")!),
        publishedAt: Date().addingTimeInterval(-3600), // 1 hour ago
        category: .technology,
        imageUrl: URL(string: "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800"),
        articleUrl: URL(string: "https://example.com/ai-healthcare-breakthrough")!,
        isBreaking: false,
        tags: ["AI", "Healthcare", "Technology", "Medicine", "Innovation"],
        likeCount: 42,
        shareCount: 15
    )
    
    /// Array of mock articles for testing
    static let mockArray: [NewsArticle] = [
        .mock,
        NewsArticle(
            id: "mock-article-2",
            title: "Climate Change Summit Reaches Historic Agreement",
            content: "World leaders have reached a historic agreement on climate change...",
            summary: "Historic climate agreement reached at global summit.",
            author: "Environmental Reporter",
            source: NewsSource(id: "global_news", name: "Global News", description: "International news coverage.", url: URL(string: "https://globalnews.com")!),
            publishedAt: Date().addingTimeInterval(-7200),
            category: .world,
            imageUrl: URL(string: "https://images.unsplash.com/photo-1611273426858-450d8e3c9fce?w=800"),
            articleUrl: URL(string: "https://example.com/climate-summit")!,
            isBreaking: true,
            tags: ["Climate", "Environment", "Global", "Politics", "Agreement"],
            likeCount: 28,
            shareCount: 32
        ),
        NewsArticle(
            id: "mock-article-3",
            title: "Tech Stocks Surge as Market Shows Strong Recovery",
            content: "Technology stocks have shown remarkable resilience...",
            summary: "Tech stocks lead market recovery with strong gains.",
            author: "Financial Analyst",
            source: NewsSource(id: "business_weekly", name: "Business Weekly", description: "Weekly business and finance news.", url: URL(string: "https://businessweekly.com")!),
            publishedAt: Date().addingTimeInterval(-10800),
            category: .business,
            imageUrl: URL(string: "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800"),
            articleUrl: URL(string: "https://example.com/tech-stocks")!,
            isBreaking: false,
            tags: ["Technology", "Stocks", "Finance", "Market", "Recovery"],
            likeCount: 15,
            shareCount: 8
        )
    ]
}

extension NewsCategory {
    /// Get random category for testing
    static var random: NewsCategory {
        return allCases.randomElement() ?? .general
    }
}
