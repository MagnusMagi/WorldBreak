import XCTest
@testable import NewsLocal

final class NetworkIntegrationTests: XCTestCase {
    
    var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager.shared
    }
    
    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
    
    func testNetworkManagerInitialization() {
        // Given & When
        let manager = NetworkManager.shared
        
        // Then
        XCTAssertNotNil(manager)
        XCTAssertEqual(manager, networkManager) // Should be singleton
    }
    
    func testConstantsConfiguration() {
        // Given & When & Then
        XCTAssertEqual(Constants.appName, "NewsLocal")
        XCTAssertEqual(Constants.apiBaseURL, "http://localhost:3000/api/v1")
        XCTAssertFalse(Constants.newsAPIKey.isEmpty)
    }
    
    func testAPIEndpoints() {
        // Given & When & Then
        XCTAssertEqual(APIEndpoints.baseURL, "http://localhost:3000/api/v1")
        XCTAssertEqual(APIEndpoints.News.topHeadlines, "http://localhost:3000/api/v1/news/headlines")
        XCTAssertEqual(APIEndpoints.News.search, "http://localhost:3000/api/v1/news/search")
        XCTAssertEqual(APIEndpoints.News.breaking, "http://localhost:3000/api/v1/news/breaking")
    }
    
    func testURLBuilding() {
        // Given
        let endpoint = APIEndpoints.News.topHeadlines
        let parameters = ["page": "1", "pageSize": "20"]
        
        // When
        let url = APIEndpoints.buildURL(endpoint, parameters: parameters)
        
        // Then
        XCTAssertNotNil(url)
        XCTAssertTrue(url?.absoluteString.contains("page=1") == true)
        XCTAssertTrue(url?.absoluteString.contains("pageSize=20") == true)
    }
    
    func testPathParameterReplacement() {
        // Given
        let endpoint = APIEndpoints.News.detail
        let pathParameters = ["id": "test-id"]
        
        // When
        let result = APIEndpoints.buildURL(endpoint, pathParameters: pathParameters)
        
        // Then
        XCTAssertTrue(result.contains("test-id"))
    }
}
