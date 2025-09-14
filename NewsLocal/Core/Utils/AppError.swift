import Foundation

// MARK: - App Error

enum AppError: LocalizedError, Equatable {
    case network(NetworkError)
    case validation(ValidationError)
    case storage(StorageError)
    case authenticationFailed
    case notAuthenticated
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.localizedDescription
        case .validation(let error):
            return error.localizedDescription
        case .storage(let error):
            return error.localizedDescription
        case .authenticationFailed:
            return "Authentication failed"
        case .notAuthenticated:
            return "User not authenticated"
        case .unknown(let message):
            return message
        }
    }
}

// MARK: - Network Errors

enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case notFound(String)
    case unauthorized
    case timeout
    case authenticationFailed
    case notAuthenticated
    case invalidResponse
    case rateLimitExceeded
    case noInternet
    case serverDown
    case networkUnavailable
    case requestTimeout
    case tokenExpired
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let code):
            return "Server error: \(code)"
        case .notFound(let message):
            return "Not found: \(message)"
        case .unauthorized:
            return "Unauthorized access"
        case .timeout:
            return "Request timeout"
        case .authenticationFailed:
            return "Authentication failed"
        case .notAuthenticated:
            return "User not authenticated"
        case .invalidResponse:
            return "Invalid response"
        case .rateLimitExceeded:
            return "Rate limit exceeded"
        case .noInternet:
            return "No internet connection"
        case .serverDown:
            return "Server is down"
        case .networkUnavailable:
            return "Network unavailable"
        case .requestTimeout:
            return "Request timeout"
        case .tokenExpired:
            return "Token expired"
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
}

// MARK: - Validation Errors

enum ValidationError: LocalizedError, Equatable {
    case invalidInput(String)
    case missingRequired(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .missingRequired(let message):
            return "Missing required field: \(message)"
        }
    }
}

// MARK: - Storage Errors

enum StorageError: LocalizedError, Equatable {
    case saveFailed
    case loadFailed
    case deleteFailed
    
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Failed to save data"
        case .loadFailed:
            return "Failed to load data"
        case .deleteFailed:
            return "Failed to delete data"
        }
    }
}
