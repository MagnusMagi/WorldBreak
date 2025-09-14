//
//  NetworkManager.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import Combine
import Network

// MARK: - Network Manager Protocol

/// Protocol defining network operations for the NewsLocal app
protocol NetworkManagerProtocol {
    /// Generic request method for fetching Decodable types
    func request<T: Decodable>(
        _ type: T.Type,
        from url: URL,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?
    ) -> AnyPublisher<T, AppError>
}

// MARK: - HTTP Method

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - Network Manager Implementation

/// Network manager for handling all API communications
class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Properties
    
    private let session: URLSession
    private let baseURL: String
    private let apiKey: String?
    private let authToken: String? // Will be used for authentication
    private let networkMonitor: NWPathMonitor
    private let networkQueue = DispatchQueue(label: "network.monitor")
    
    // MARK: - Initialization
    
    init(
        baseURL: String = Constants.API.apiBaseURL, // Use Constants.API.apiBaseURL
        apiKey: String? = Constants.API.newsAPIKey, // Use Constants.API.newsAPIKey
        authToken: String? = nil,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.authToken = authToken
        self.session = session
        self.networkMonitor = NWPathMonitor()
        
        setupNetworkMonitoring()
    }
    
    // MARK: - Network Monitoring
    
    private func setupNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("Network connection is available")
                } else {
                    print("Network connection is not available")
                }
            }
        }
        networkMonitor.start(queue: networkQueue)
    }
    
    // MARK: - Generic Request
    
    func request<T: Decodable>(
        _ type: T.Type,
        from url: URL,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) -> AnyPublisher<T, AppError> {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = buildHeaders(additionalHeaders: headers)
        request.httpBody = body
        request.timeoutInterval = Constants.API.networkTimeout // Use Constants.API.networkTimeout
        
        return session.dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                try self?.validateResponse(data: data, response: response)
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let appError = error as? AppError {
                    return appError
                } else if let urlError = error as? URLError {
                    return AppError.network(NetworkError.fromURLError(urlError))
                } else if let decodingError = error as? DecodingError {
                    return AppError.network(NetworkError.fromDecodingError(decodingError))
                } else {
                    return AppError.unknown(error.localizedDescription)
                }
            }
            .retry(Constants.API.networkRetryCount)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    
    private func buildHeaders(additionalHeaders: [String: String]? = nil) -> [String: String] {
        var headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if let apiKey = apiKey {
            headers["X-API-Key"] = apiKey
        }
        
        if let authToken = authToken {
            headers["Authorization"] = "Bearer \(authToken)"
        }
        
        if let additionalHeaders = additionalHeaders {
            headers.merge(additionalHeaders) { _, new in new }
        }
        
        return headers
    }
    
    private func validateResponse(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.network(.invalidResponse)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return // Success
        case 400:
            throw AppError.validation(.invalidInput("Bad Request"))
        case 401:
            throw AppError.network(.unauthorized)
        case 403:
            throw AppError.network(.unauthorized) // Or specific forbidden error
        case 404:
            throw AppError.network(.notFound("Resource not found"))
        case 408:
            throw AppError.network(.timeout)
        case 429:
            throw AppError.network(.rateLimitExceeded)
        case 500...599:
            throw AppError.network(.serverError(httpResponse.statusCode))
        default:
            throw AppError.unknown("Unhandled HTTP status code: \(httpResponse.statusCode)")
        }
    }
}

// MARK: - AppError Extensions for Network Errors

extension NetworkError {
    static func fromURLError(_ urlError: URLError) -> NetworkError {
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .noInternet
        case .timedOut:
            return .timeout
        case .cannotFindHost, .cannotConnectToHost:
            return .serverDown
        case .badServerResponse:
            return .invalidResponse
        case .userCancelledAuthentication:
            return .unauthorized
        default:
            return .unknown("URL Error: \(urlError.localizedDescription)")
        }
    }
    
    static func fromDecodingError(_ decodingError: DecodingError) -> NetworkError {
        let message: String
        switch decodingError {
        case .typeMismatch(let type, let context):
            message = "Type mismatch for \(type): \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            message = "Value not found for \(type): \(context.debugDescription)"
        case .keyNotFound(let key, let context):
            message = "Key not found: \(key) - \(context.debugDescription)"
        case .dataCorrupted(let context):
            message = "Data corrupted: \(context.debugDescription)"
        @unknown default:
            message = "Unknown decoding error"
        }
        return .decodingError
    }
}

// MARK: - Mock Network Manager

/// Mock implementation for testing and previews
class MockNetworkManager: NetworkManagerProtocol {
    
    private let mockData: [String: Any] = [:]
    private let shouldFail: Bool
    private let delay: TimeInterval
    
    init(shouldFail: Bool = false, delay: TimeInterval = 0.5) {
        self.shouldFail = shouldFail
        self.delay = delay
    }
    
    func request<T: Decodable>(
        _ type: T.Type,
        from url: URL,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?
    ) -> AnyPublisher<T, AppError> {
        return performMockRequest(url: url)
    }
    
    private func performMockRequest<T: Decodable>(url: URL) -> AnyPublisher<T, AppError> {
        if shouldFail {
            return Fail(error: AppError.network(.networkUnavailable))
                .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        // Return mock data based on URL
        let mockData: Any
        
        // This part of the mock needs to be updated to reflect the actual mock data
        // For now, it's a placeholder.
        if url.pathComponents.contains("articles") {
            mockData = NewsArticle.mockArray
        } else if url.pathComponents.contains("categories") {
            mockData = NewsCategory.allCases
        } else if url.pathComponents.contains("sources") {
            mockData = [NewsSource]()
        } else if url.pathComponents.contains("user") {
            mockData = User.mock
        } else {
            mockData = [String: String]()
        }
        
        return Just(mockData as! T)
            .setFailureType(to: AppError.self)
            .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - Network Status

/// Network connectivity status
enum NetworkStatus {
    case connected
    case disconnected
    case cellular
    case wifi
    case unknown
    
    var isConnected: Bool {
        switch self {
        case .connected, .cellular, .wifi:
            return true
        case .disconnected, .unknown:
            return false
        }
    }
}

// MARK: - Network Monitor

/// Network connectivity monitor
class NetworkMonitor: ObservableObject {
    @Published var status: NetworkStatus = .unknown
    @Published var isConnected: Bool = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "network.monitor")
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.updateStatus(path: path)
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
    
    private func updateStatus(path: NWPath) {
        switch path.status {
        case .satisfied:
            if path.usesInterfaceType(.wifi) {
                status = .wifi
            } else if path.usesInterfaceType(.cellular) {
                status = .cellular
            } else {
                status = .connected
            }
        case .unsatisfied:
            status = .disconnected
        case .requiresConnection:
            status = .unknown
        @unknown default:
            status = .unknown
        }
        
        isConnected = status.isConnected
    }
}

// MARK: - Network Error Extensions

extension AppError {
    
    /// Check if error is network-related
    var isNetworkError: Bool {
        switch self {
        case .network(.networkUnavailable), .network(.requestTimeout), .network(.serverError), .network(.invalidResponse):
            return true
        default:
            return false
        }
    }
    
    /// Check if error is retryable
    var isRetryable: Bool {
        switch self {
        case .network(.networkUnavailable), .network(.requestTimeout), .network(.serverError):
            return true
        case .network(.authenticationFailed), .network(.notAuthenticated), .network(.tokenExpired):
            return false
        default:
            return false
        }
    }
}

// MARK: - Async/Await Support

@available(iOS 13.0, *)
extension NetworkManagerProtocol {
    
    /// Perform GET request with async/await
    func request<T: Decodable>(
        _ type: T.Type,
        from url: URL,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            let cancellable = request(type, from: url, method: method, headers: headers, body: body)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                    }
                )
            _ = cancellable
        }
    }
}
