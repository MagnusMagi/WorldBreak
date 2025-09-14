import XCTest
import Combine
@testable import NewsLocal

final class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var mockNewsService: MockNewsService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNewsService = MockNewsService()
        viewModel = HomeViewModel(newsService: mockNewsService)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockNewsService = nil
        super.tearDown()
    }
    
    func testLoadNews() {
        // Given
        let expectation = XCTestExpectation(description: "Load news")
        
        // When
        viewModel.loadNews()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertFalse(self.viewModel.articles.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSearchNews() {
        // Given
        let expectation = XCTestExpectation(description: "Search news")
        let searchQuery = "technology"
        
        // When
        viewModel.searchNews(query: searchQuery)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            // Note: Mock service returns all articles for any search query
            XCTAssertFalse(self.viewModel.articles.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFilterByCategory() {
        // Given
        let expectation = XCTestExpectation(description: "Filter by category")
        let category = NewsCategory.technology
        
        // When
        viewModel.filterByCategory(category)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertFalse(self.viewModel.articles.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSelectArticle() {
        // Given
        let mockArticles = MockDataGenerator.generateMockArticles(count: 1)
        let article = mockArticles.first!
        
        // When
        viewModel.selectArticle(article)
        
        // Then
        XCTAssertEqual(viewModel.selectedArticle?.id, article.id)
    }
    
    func testRefreshNews() {
        // Given
        let expectation = XCTestExpectation(description: "Refresh news")
        
        // When
        viewModel.refreshNews()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertFalse(self.viewModel.articles.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadingState() {
        // Given
        let expectation = XCTestExpectation(description: "Loading state")
        
        // When
        viewModel.loadNews()
        
        // Then - Initially should be loading
        XCTAssertTrue(viewModel.isLoading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
