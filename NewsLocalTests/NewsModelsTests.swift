import XCTest
@testable import NewsLocal

final class NewsModelsTests: XCTestCase {
    
    func testNewsArticleModel() {
        // Given
        let source = NewsSource(
            id: "source-id",
            name: "Test Source",
            description: "Test source description",
            url: URL(string: "https://example.com")!,
            logoUrl: URL(string: "https://example.com/logo.jpg")
        )
        
        let article = NewsArticle(
            id: "test-id",
            title: "Test Title",
            content: "Test Content",
            summary: "Test Summary",
            author: "Test Author",
            source: source,
            publishedAt: Date(),
            category: .technology,
                imageUrl: URL(string: "https://example.com/image.jpg"),
                articleUrl: URL(string: "https://example.com/article")!,
                isBreaking: true,
                tags: ["Technology", "AI", "Innovation"],
                likeCount: 25,
                shareCount: 10
        )
        
        // When & Then
        XCTAssertEqual(article.id, "test-id")
        XCTAssertEqual(article.title, "Test Title")
        XCTAssertEqual(article.content, "Test Content")
        XCTAssertEqual(article.summary, "Test Summary")
        XCTAssertEqual(article.author, "Test Author")
        XCTAssertEqual(article.category, .technology)
        XCTAssertEqual(article.imageUrl?.absoluteString, "https://example.com/image.jpg")
        XCTAssertEqual(article.source.id, "source-id")
        XCTAssertEqual(article.source.name, "Test Source")
        XCTAssertTrue(article.isBreaking)
        XCTAssertEqual(article.tags, ["Technology", "AI", "Innovation"])
        XCTAssertEqual(article.likeCount, 25)
        XCTAssertEqual(article.shareCount, 10)
    }
    
    func testNewsResponseModel() {
        // Given
        let source = NewsSource(
            id: "1",
            name: "Source 1",
            description: "Test source",
            url: URL(string: "https://example.com")!,
            logoUrl: nil
        )
        
        let articles = [
            NewsArticle(
                id: "1",
                title: "Article 1",
                content: "Content 1",
                summary: "Summary 1",
                author: "Author 1",
                source: source,
                publishedAt: Date(),
                category: .technology,
                imageUrl: nil,
                articleUrl: URL(string: "https://example.com/article1")!,
                isBreaking: false,
                tags: ["Test", "Article"],
                likeCount: 5,
                shareCount: 2
            )
        ]
        
        let response = NewsResponse(
            articles: articles,
            totalResults: 1,
            page: 1,
            pageSize: 20,
            hasMore: false
        )
        
        // When & Then
        XCTAssertEqual(response.articles.count, 1)
        XCTAssertEqual(response.totalResults, 1)
        XCTAssertEqual(response.page, 1)
        XCTAssertEqual(response.pageSize, 20)
        XCTAssertFalse(response.hasMore)
    }
    
    func testNewsCategoryEnum() {
        // Given & When & Then
        XCTAssertEqual(NewsCategory.technology.rawValue, "technology")
        XCTAssertEqual(NewsCategory.business.rawValue, "business")
        XCTAssertEqual(NewsCategory.sports.rawValue, "sports")
        XCTAssertEqual(NewsCategory.health.rawValue, "health")
        XCTAssertEqual(NewsCategory.science.rawValue, "science")
        XCTAssertEqual(NewsCategory.entertainment.rawValue, "entertainment")
        XCTAssertEqual(NewsCategory.politics.rawValue, "politics")
        XCTAssertEqual(NewsCategory.world.rawValue, "world")
    }
    
    func testNewsSourceModel() {
        // Given
        let source = NewsSource(
            id: "source-id",
            name: "Source Name",
            description: "Source description",
            url: URL(string: "https://example.com")!,
            logoUrl: URL(string: "https://example.com/logo.jpg")
        )
        
        // When & Then
        XCTAssertEqual(source.id, "source-id")
        XCTAssertEqual(source.name, "Source Name")
        XCTAssertEqual(source.description, "Source description")
        XCTAssertEqual(source.url.absoluteString, "https://example.com")
        XCTAssertEqual(source.logoUrl?.absoluteString, "https://example.com/logo.jpg")
    }
    
    func testUserPreferencesModel() {
        // Given
        let preferences = UserPreferences(
            preferredCategories: [.technology, .business],
            preferredSources: ["Source 1", "Source 2"],
            notificationSettings: NotificationSettings(
                breakingNews: true,
                categoryUpdates: false,
                personalizedNews: true,
                pushNotifications: true
            ),
            readingPreferences: ReadingPreferences(
                fontSize: .medium,
                darkMode: false,
                autoPlayVideos: true,
                showImages: true
            ),
            location: "New York"
        )
        
        // When & Then
        XCTAssertEqual(preferences.preferredCategories.count, 2)
        XCTAssertEqual(preferences.preferredSources.count, 2)
        XCTAssertTrue(preferences.notificationSettings.breakingNews)
        XCTAssertFalse(preferences.notificationSettings.categoryUpdates)
        XCTAssertEqual(preferences.readingPreferences.fontSize, .medium)
        XCTAssertFalse(preferences.readingPreferences.darkMode)
        XCTAssertEqual(preferences.location, "New York")
    }
    
    func testNotificationSettingsModel() {
        // Given
        let settings = NotificationSettings(
            breakingNews: true,
            categoryUpdates: false,
            personalizedNews: true,
            pushNotifications: false
        )
        
        // When & Then
        XCTAssertTrue(settings.breakingNews)
        XCTAssertFalse(settings.categoryUpdates)
        XCTAssertTrue(settings.personalizedNews)
        XCTAssertFalse(settings.pushNotifications)
    }
    
    func testReadingPreferencesModel() {
        // Given
        let preferences = ReadingPreferences(
            fontSize: .large,
            darkMode: true,
            autoPlayVideos: false,
            showImages: true
        )
        
        // When & Then
        XCTAssertEqual(preferences.fontSize, .large)
        XCTAssertTrue(preferences.darkMode)
        XCTAssertFalse(preferences.autoPlayVideos)
        XCTAssertTrue(preferences.showImages)
    }
    
    func testFontSizeEnum() {
        // Given & When & Then
        XCTAssertEqual(ReadingPreferences.FontSize.small.rawValue, "small")
        XCTAssertEqual(ReadingPreferences.FontSize.medium.rawValue, "medium")
        XCTAssertEqual(ReadingPreferences.FontSize.large.rawValue, "large")
    }
}
