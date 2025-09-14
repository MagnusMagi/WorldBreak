import XCTest
@testable import NewsLocal

final class MockDataGeneratorTests: XCTestCase {
    
    func testGenerateMockArticles() {
        // Given
        let count = 10
        
        // When
        let articles = MockDataGenerator.generateMockArticles(count: count)
        
        // Then
        XCTAssertEqual(articles.count, count)
        
        for article in articles {
            XCTAssertFalse(article.id.isEmpty)
            XCTAssertFalse(article.title.isEmpty)
            XCTAssertFalse(article.content.isEmpty)
            XCTAssertFalse(article.author.isEmpty)
            XCTAssertNotNil(article.imageURL)
            XCTAssertGreaterThan(article.readTime, 0)
            XCTAssertGreaterThanOrEqual(article.shareCount, 0)
            XCTAssertGreaterThanOrEqual(article.likeCount, 0)
        }
    }
    
    func testMockArticleProperties() {
        // Given
        let articles = MockDataGenerator.generateMockArticles(count: 5)
        
        // When
        let article = articles.first!
        
        // Then
        XCTAssertTrue(article.id.hasPrefix("article_"))
        XCTAssertFalse(article.summary.isEmpty)
        XCTAssertTrue(article.summary.count <= 153) // 150 + "..."
        XCTAssertNotNil(article.source.id)
        XCTAssertFalse(article.source.name.isEmpty)
    }
}
