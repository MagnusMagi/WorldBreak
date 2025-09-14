//
//  UserServiceProtocol.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import Combine

// MARK: - User Service Protocol

/// Protocol defining the interface for user-related operations
protocol UserServiceProtocol {
    
    // MARK: - Authentication
    
    /// Register a new user account
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    ///   - name: User's display name
    /// - Returns: Publisher that emits the created user
    func register(email: String, password: String, name: String) -> AnyPublisher<User, AppError>
    
    /// Login with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Publisher that emits the authenticated user
    func login(email: String, password: String) -> AnyPublisher<User, AppError>
    
    /// Login with social media account
    /// - Parameters:
    ///   - provider: Social media provider (Google, Apple, Facebook)
    ///   - token: Authentication token from provider
    /// - Returns: Publisher that emits the authenticated user
    func loginWithSocial(provider: SocialProvider, token: String) -> AnyPublisher<User, AppError>
    
    /// Logout current user
    /// - Returns: Publisher that emits success status
    func logout() -> AnyPublisher<Bool, AppError>
    
    /// Refresh authentication token
    /// - Returns: Publisher that emits new authentication token
    func refreshToken() -> AnyPublisher<String, AppError>
    
    /// Verify email address
    /// - Parameter token: Email verification token
    /// - Returns: Publisher that emits success status
    func verifyEmail(token: String) -> AnyPublisher<Bool, AppError>
    
    /// Resend email verification
    /// - Returns: Publisher that emits success status
    func resendEmailVerification() -> AnyPublisher<Bool, AppError>
    
    // MARK: - Password Management
    
    /// Change user password
    /// - Parameters:
    ///   - currentPassword: Current password
    ///   - newPassword: New password
    /// - Returns: Publisher that emits success status
    func changePassword(currentPassword: String, newPassword: String) -> AnyPublisher<Bool, AppError>
    
    /// Request password reset
    /// - Parameter email: User's email address
    /// - Returns: Publisher that emits success status
    func requestPasswordReset(email: String) -> AnyPublisher<Bool, AppError>
    
    /// Reset password with token
    /// - Parameters:
    ///   - token: Password reset token
    ///   - newPassword: New password
    /// - Returns: Publisher that emits success status
    func resetPassword(token: String, newPassword: String) -> AnyPublisher<Bool, AppError>
    
    // MARK: - Profile Management
    
    /// Get current user profile
    /// - Returns: Publisher that emits current user data
    func getCurrentUser() -> AnyPublisher<User, AppError>
    
    /// Update user profile
    /// - Parameters:
    ///   - name: New display name
    ///   - profileImageUrl: New profile image URL
    /// - Returns: Publisher that emits updated user data
    func updateProfile(name: String?, profileImageUrl: URL?) -> AnyPublisher<User, AppError>
    
    /// Update user preferences
    /// - Parameter preferences: New user preferences
    /// - Returns: Publisher that emits updated user data
    func updatePreferences(_ preferences: UserPreferences) -> AnyPublisher<User, AppError>
    
    /// Delete user account
    /// - Returns: Publisher that emits success status
    func deleteAccount() -> AnyPublisher<Bool, AppError>
    
    // MARK: - User Statistics and Analytics
    
    /// Get user reading statistics
    /// - Returns: Publisher that emits user statistics
    func getUserStatistics() -> AnyPublisher<UserStatistics, AppError>
    
    /// Track user activity
    /// - Parameter activity: User activity to track
    /// - Returns: Publisher that emits success status
    func trackActivity(_ activity: UserActivity) -> AnyPublisher<Bool, AppError>
    
    /// Get user activity history
    /// - Parameters:
    ///   - page: Page number for pagination
    ///   - limit: Number of activities per page
    /// - Returns: Publisher that emits array of user activities
    func getActivityHistory(page: Int, limit: Int) -> AnyPublisher<[UserActivity], AppError>
    
    /// Get user reading insights
    /// - Returns: Publisher that emits reading insights
    func getReadingInsights() -> AnyPublisher<ReadingInsights, AppError>
    
    // MARK: - Sessions and Devices
    
    /// Start new user session
    /// - Parameter deviceInfo: Device information
    /// - Returns: Publisher that emits new session
    func startSession(deviceInfo: UserSession.DeviceInfo) -> AnyPublisher<UserSession, AppError>
    
    /// End current user session
    /// - Returns: Publisher that emits success status
    func endSession() -> AnyPublisher<Bool, AppError>
    
    /// Get active user sessions
    /// - Returns: Publisher that emits array of active sessions
    func getActiveSessions() -> AnyPublisher<[UserSession], AppError>
    
    /// Terminate specific session
    /// - Parameter sessionId: Session ID to terminate
    /// - Returns: Publisher that emits success status
    func terminateSession(sessionId: String) -> AnyPublisher<Bool, AppError>
    
    // MARK: - Notifications
    
    /// Update notification preferences
    /// - Parameter preferences: New notification preferences
    /// - Returns: Publisher that emits success status
    func updateNotificationPreferences(_ preferences: NotificationPreferences) -> AnyPublisher<Bool, AppError>
    
    /// Register for push notifications
    /// - Parameter deviceToken: Device token for push notifications
    /// - Returns: Publisher that emits success status
    func registerForPushNotifications(deviceToken: String) -> AnyPublisher<Bool, AppError>
    
    /// Unregister from push notifications
    /// - Returns: Publisher that emits success status
    func unregisterFromPushNotifications() -> AnyPublisher<Bool, AppError>
    
    /// Get notification history
    /// - Parameters:
    ///   - page: Page number for pagination
    ///   - limit: Number of notifications per page
    /// - Returns: Publisher that emits array of notifications
    func getNotificationHistory(page: Int, limit: Int) -> AnyPublisher<[Notification], AppError>
    
    /// Mark notification as read
    /// - Parameter notificationId: Notification ID to mark as read
    /// - Returns: Publisher that emits success status
    func markNotificationAsRead(notificationId: String) -> AnyPublisher<Bool, AppError>
    
    /// Mark all notifications as read
    /// - Returns: Publisher that emits success status
    func markAllNotificationsAsRead() -> AnyPublisher<Bool, AppError>
    
    // MARK: - Privacy and Data
    
    /// Export user data
    /// - Returns: Publisher that emits user data export
    func exportUserData() -> AnyPublisher<UserDataExport, AppError>
    
    /// Delete user data
    /// - Parameter dataTypes: Types of data to delete
    /// - Returns: Publisher that emits success status
    func deleteUserData(dataTypes: [DataType]) -> AnyPublisher<Bool, AppError>
    
    /// Update privacy preferences
    /// - Parameter preferences: New privacy preferences
    /// - Returns: Publisher that emits success status
    func updatePrivacyPreferences(_ preferences: PrivacyPreferences) -> AnyPublisher<Bool, AppError>
    
    /// Get data usage consent
    /// - Returns: Publisher that emits consent status
    func getDataUsageConsent() -> AnyPublisher<DataUsageConsent, AppError>
    
    /// Update data usage consent
    /// - Parameter consent: New consent status
    /// - Returns: Publisher that emits success status
    func updateDataUsageConsent(_ consent: DataUsageConsent) -> AnyPublisher<Bool, AppError>
}

// MARK: - Supporting Types

/// Social media providers for authentication
enum SocialProvider: String, Codable, CaseIterable {
    case google = "google"
    case apple = "apple"
    case facebook = "facebook"
    case twitter = "twitter"
    
    var displayName: String {
        switch self {
        case .google: return "Google"
        case .apple: return "Apple"
        case .facebook: return "Facebook"
        case .twitter: return "Twitter"
        }
    }
}

/// Reading insights for user analytics
struct ReadingInsights: Codable, Equatable {
    let totalReadingTime: TimeInterval
    let averageSessionDuration: TimeInterval
    let favoriteCategories: [String: Int]
    let favoriteSources: [String: Int]
    let readingStreak: Int
    let weeklyGoal: Int
    let weeklyProgress: Int
    let monthlyGoal: Int
    let monthlyProgress: Int
    let readingPatterns: [String: Int] // Day of week -> reading time
    let peakReadingHours: [Int] // Hours when user reads most
    let lastUpdated: Date
    
    // MARK: - Computed Properties
    
    var weeklyGoalPercentage: Double {
        guard weeklyGoal > 0 else { return 0 }
        return Double(weeklyProgress) / Double(weeklyGoal) * 100
    }
    
    var monthlyGoalPercentage: Double {
        guard monthlyGoal > 0 else { return 0 }
        return Double(monthlyProgress) / Double(monthlyGoal) * 100
    }
    
    var formattedTotalReadingTime: String {
        let hours = Int(totalReadingTime) / 3600
        let minutes = (Int(totalReadingTime) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var formattedAverageSessionDuration: String {
        let minutes = Int(averageSessionDuration) / 60
        let seconds = Int(averageSessionDuration) % 60
        
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
}

/// Notification model for user notifications
struct Notification: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let message: String
    let type: NotificationType
    let priority: NotificationPriority
    let isRead: Bool
    let createdAt: Date
    let actionUrl: URL?
    let metadata: [String: String]
    
    // MARK: - Notification Type
    
    enum NotificationType: String, Codable, CaseIterable {
        case breakingNews = "breaking_news"
        case trendingNews = "trending_news"
        case categoryUpdate = "category_update"
        case weeklyDigest = "weekly_digest"
        case systemUpdate = "system_update"
        case securityAlert = "security_alert"
        case achievement = "achievement"
        
        var displayName: String {
            switch self {
            case .breakingNews: return "Breaking News"
            case .trendingNews: return "Trending News"
            case .categoryUpdate: return "Category Update"
            case .weeklyDigest: return "Weekly Digest"
            case .systemUpdate: return "System Update"
            case .securityAlert: return "Security Alert"
            case .achievement: return "Achievement"
            }
        }
    }
    
    // MARK: - Notification Priority
    
    enum NotificationPriority: String, Codable, CaseIterable {
        case low = "low"
        case normal = "normal"
        case high = "high"
        case urgent = "urgent"
        
        var displayName: String {
            switch self {
            case .low: return "Low"
            case .normal: return "Normal"
            case .high: return "High"
            case .urgent: return "Urgent"
            }
        }
    }
}

/// User data export model
struct UserDataExport: Codable, Equatable {
    let userId: String
    let exportDate: Date
    let dataTypes: [DataType]
    let downloadUrl: URL
    let expiresAt: Date
    let fileSize: Int64
    
    // MARK: - Data Type
    
    enum DataType: String, Codable, CaseIterable {
        case profile = "profile"
        case preferences = "preferences"
        case readingHistory = "reading_history"
        case activityLog = "activity_log"
        case notifications = "notifications"
        case bookmarks = "bookmarks"
        case statistics = "statistics"
        
        var displayName: String {
            switch self {
            case .profile: return "Profile Information"
            case .preferences: return "User Preferences"
            case .readingHistory: return "Reading History"
            case .activityLog: return "Activity Log"
            case .notifications: return "Notifications"
            case .bookmarks: return "Bookmarks"
            case .statistics: return "Statistics"
            }
        }
    }
    
    // MARK: - Computed Properties
    
    var formattedFileSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: fileSize)
    }
    
    var isExpired: Bool {
        return Date() > expiresAt
    }
}

/// Data usage consent model
struct DataUsageConsent: Codable, Equatable {
    let analytics: Bool
    let personalization: Bool
    let marketing: Bool
    let thirdPartySharing: Bool
    let locationTracking: Bool
    let crashReporting: Bool
    let performanceMonitoring: Bool
    let lastUpdated: Date
    let version: String
    
    // MARK: - Computed Properties
    
    var hasAnyConsent: Bool {
        return analytics || personalization || marketing || thirdPartySharing || 
               locationTracking || crashReporting || performanceMonitoring
    }
    
    var hasAllConsent: Bool {
        return analytics && personalization && marketing && thirdPartySharing && 
               locationTracking && crashReporting && performanceMonitoring
    }
}

// MARK: - Async/Await Support

/// Extension providing async/await support for UserServiceProtocol
@available(iOS 13.0, *)
extension UserServiceProtocol {
    
    // MARK: - Authentication (Async)
    
    /// Register a new user account (Async)
    func register(email: String, password: String, name: String) async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = register(email: email, password: password, name: name)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { user in
                        continuation.resume(returning: user)
                        cancellable?.cancel()
                    }
                )
        }
    }
    
    /// Login with email and password (Async)
    func login(email: String, password: String) async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = login(email: email, password: password)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { user in
                        continuation.resume(returning: user)
                        cancellable?.cancel()
                    }
                )
        }
    }
    
    /// Logout current user (Async)
    func logout() async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = logout()
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { success in
                        continuation.resume(returning: success)
                        cancellable?.cancel()
                    }
                )
        }
    }
    
    /// Get current user profile (Async)
    func getCurrentUser() async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = getCurrentUser()
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { user in
                        continuation.resume(returning: user)
                        cancellable?.cancel()
                    }
                )
        }
    }
    
    /// Update user preferences (Async)
    func updatePreferences(_ preferences: UserPreferences) async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = updatePreferences(preferences)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { user in
                        continuation.resume(returning: user)
                        cancellable?.cancel()
                    }
                )
        }
    }
    
    /// Track user activity (Async)
    func trackActivity(_ activity: UserActivity) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = trackActivity(activity)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { success in
                        continuation.resume(returning: success)
                        cancellable?.cancel()
                    }
                )
        }
    }
    
    /// Get user statistics (Async)
    func getUserStatistics() async throws -> UserStatistics {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = getUserStatistics()
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { statistics in
                        continuation.resume(returning: statistics)
                        cancellable?.cancel()
                    }
                )
        }
    }
}

// MARK: - Mock Implementation for Testing

/// Mock implementation of UserServiceProtocol for testing and previews
class MockUserService: UserServiceProtocol {
    
    private var currentUser: User?
    private var isAuthenticated: Bool = false
    
    init(currentUser: User? = User.mock) {
        self.currentUser = currentUser
        self.isAuthenticated = currentUser != nil
    }
    
    // MARK: - Authentication
    
    func register(email: String, password: String, name: String) -> AnyPublisher<User, AppError> {
        let newUser = User(
            email: email,
            name: name,
            preferences: UserPreferences(),
            statistics: UserStatistics()
        )
        
        currentUser = newUser
        isAuthenticated = true
        
        return Just(newUser)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func login(email: String, password: String) -> AnyPublisher<User, AppError> {
        guard let user = currentUser, user.email == email else {
            return Fail(error: AppError.network(.authenticationFailed))
                .eraseToAnyPublisher()
        }
        
        isAuthenticated = true
        
        return Just(user)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func loginWithSocial(provider: SocialProvider, token: String) -> AnyPublisher<User, AppError> {
        // Mock implementation - always returns current user
        guard let user = currentUser else {
            return Fail(error: AppError.network(.authenticationFailed))
                .eraseToAnyPublisher()
        }
        
        isAuthenticated = true
        
        return Just(user)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Bool, AppError> {
        isAuthenticated = false
        
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func refreshToken() -> AnyPublisher<String, AppError> {
        // Mock implementation - returns dummy token
        return Just("mock-refresh-token")
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func verifyEmail(token: String) -> AnyPublisher<Bool, AppError> {
        // Mock implementation - always returns success
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func resendEmailVerification() -> AnyPublisher<Bool, AppError> {
        // Mock implementation - always returns success
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Password Management
    
    func changePassword(currentPassword: String, newPassword: String) -> AnyPublisher<Bool, AppError> {
        // Mock implementation - always returns success
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func requestPasswordReset(email: String) -> AnyPublisher<Bool, AppError> {
        // Mock implementation - always returns success
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func resetPassword(token: String, newPassword: String) -> AnyPublisher<Bool, AppError> {
        // Mock implementation - always returns success
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Profile Management
    
    func getCurrentUser() -> AnyPublisher<User, AppError> {
        guard let user = currentUser, isAuthenticated else {
            return Fail(error: AppError.network(.notAuthenticated))
                .eraseToAnyPublisher()
        }
        
        return Just(user)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func updateProfile(name: String?, profileImageUrl: URL?) -> AnyPublisher<User, AppError> {
        guard let user = currentUser, isAuthenticated else {
            return Fail(error: AppError.network(.notAuthenticated))
                .eraseToAnyPublisher()
        }
        
        // Mock update - create new user with updated fields
        let updatedUser = User(
            id: user.id,
            email: user.email,
            name: name ?? user.name,
            profileImageUrl: profileImageUrl ?? user.profileImageUrl,
            preferences: user.preferences,
            statistics: user.statistics,
            createdAt: user.createdAt,
            lastActiveAt: Date(),
            isEmailVerified: user.isEmailVerified,
            isPremium: user.isPremium
        )
        
        currentUser = updatedUser
        
        return Just(updatedUser)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func updatePreferences(_ preferences: UserPreferences) -> AnyPublisher<User, AppError> {
        guard let user = currentUser, isAuthenticated else {
            return Fail(error: AppError.network(.notAuthenticated))
                .eraseToAnyPublisher()
        }
        
        // Mock update - create new user with updated preferences
        let updatedUser = User(
            id: user.id,
            email: user.email,
            name: user.name,
            profileImageUrl: user.profileImageUrl,
            preferences: preferences,
            statistics: user.statistics,
            createdAt: user.createdAt,
            lastActiveAt: Date(),
            isEmailVerified: user.isEmailVerified,
            isPremium: user.isPremium
        )
        
        currentUser = updatedUser
        
        return Just(updatedUser)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func deleteAccount() -> AnyPublisher<Bool, AppError> {
        currentUser = nil
        isAuthenticated = false
        
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - User Statistics and Analytics
    
    func getUserStatistics() -> AnyPublisher<UserStatistics, AppError> {
        guard let user = currentUser, isAuthenticated else {
            return Fail(error: AppError.network(.notAuthenticated))
                .eraseToAnyPublisher()
        }
        
        return Just(user.statistics)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func trackActivity(_ activity: UserActivity) -> AnyPublisher<Bool, AppError> {
        // Mock implementation - always returns success
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func getActivityHistory(page: Int, limit: Int) -> AnyPublisher<[UserActivity], AppError> {
        // Mock implementation - returns empty array
        return Just([])
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func getReadingInsights() -> AnyPublisher<ReadingInsights, AppError> {
        // Mock implementation - returns default insights
        let insights = ReadingInsights(
            totalReadingTime: 7200,
            averageSessionDuration: 300,
            favoriteCategories: ["technology": 45, "science": 32],
            favoriteSources: ["TechNews": 25, "ScienceDaily": 20],
            readingStreak: 7,
            weeklyGoal: 100,
            weeklyProgress: 75,
            monthlyGoal: 500,
            monthlyProgress: 320,
            readingPatterns: ["Monday": 120, "Tuesday": 180, "Wednesday": 150],
            peakReadingHours: [9, 12, 18],
            lastUpdated: Date()
        )
        
        return Just(insights)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Sessions and Devices
    
    func startSession(deviceInfo: UserSession.DeviceInfo) -> AnyPublisher<UserSession, AppError> {
        let session = UserSession(
            userId: currentUser?.id ?? "mock-user",
            deviceInfo: deviceInfo
        )
        
        return Just(session)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func endSession() -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func getActiveSessions() -> AnyPublisher<[UserSession], AppError> {
        // Mock implementation - returns empty array
        return Just([])
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func terminateSession(sessionId: String) -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Notifications
    
    func updateNotificationPreferences(_ preferences: NotificationPreferences) -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func registerForPushNotifications(deviceToken: String) -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func unregisterFromPushNotifications() -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func getNotificationHistory(page: Int, limit: Int) -> AnyPublisher<[Notification], AppError> {
        // Mock implementation - returns empty array
        return Just([])
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func markNotificationAsRead(notificationId: String) -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func markAllNotificationsAsRead() -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Privacy and Data
    
    func exportUserData() -> AnyPublisher<UserDataExport, AppError> {
        let export = UserDataExport(
            userId: currentUser?.id ?? "mock-user",
            exportDate: Date(),
            dataTypes: [.profile, .preferences, .readingHistory],
            downloadUrl: URL(string: "https://example.com/export.zip")!,
            expiresAt: Date().addingTimeInterval(86400 * 7), // 7 days
            fileSize: 1024 * 1024 // 1MB
        )
        
        return Just(export)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func deleteUserData(dataTypes: [DataType]) -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func updatePrivacyPreferences(_ preferences: PrivacyPreferences) -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func getDataUsageConsent() -> AnyPublisher<DataUsageConsent, AppError> {
        let consent = DataUsageConsent(
            analytics: true,
            personalization: true,
            marketing: false,
            thirdPartySharing: false,
            locationTracking: false,
            crashReporting: true,
            performanceMonitoring: true,
            lastUpdated: Date(),
            version: "1.0"
        )
        
        return Just(consent)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func updateDataUsageConsent(_ consent: DataUsageConsent) -> AnyPublisher<Bool, AppError> {
        return Just(true)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
}
