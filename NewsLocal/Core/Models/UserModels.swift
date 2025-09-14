//
//  UserModels.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import UIKit

// MARK: - User Model

/// Represents a user account with preferences and activity data
struct User: Identifiable, Codable, Equatable {
    let id: String
    let email: String
    let name: String
    let profileImageUrl: URL?
    let preferences: UserPreferences
    let statistics: UserStatistics
    let createdAt: Date
    let lastActiveAt: Date
    let isEmailVerified: Bool
    let isPremium: Bool
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id, email, name, preferences, statistics
        case profileImageUrl = "profile_image_url"
        case createdAt = "created_at"
        case lastActiveAt = "last_active_at"
        case isEmailVerified = "is_email_verified"
        case isPremium = "is_premium"
    }
    
    // MARK: - Initializers
    
    init(
        id: String = UUID().uuidString,
        email: String,
        name: String,
        profileImageUrl: URL? = nil,
        preferences: UserPreferences = UserPreferences(),
        statistics: UserStatistics = UserStatistics(),
        createdAt: Date = Date(),
        lastActiveAt: Date = Date(),
        isEmailVerified: Bool = false,
        isPremium: Bool = false
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.profileImageUrl = profileImageUrl
        self.preferences = preferences
        self.statistics = statistics
        self.createdAt = createdAt
        self.lastActiveAt = lastActiveAt
        self.isEmailVerified = isEmailVerified
        self.isPremium = isPremium
    }
}

// MARK: - User Preferences Model

/// User preferences for personalization and app behavior
struct UserPreferences: Codable, Equatable {
    var categories: [NewsCategory]
    var sources: [NewsSource]
    var darkMode: Bool
    var notifications: NotificationPreferences
    var reading: ReadingPreferences
    var privacy: PrivacyPreferences
    var language: String
    var country: String
    var timezone: String
    
    // MARK: - Initializers
    
    init(
        categories: [NewsCategory] = [],
        sources: [NewsSource] = [],
        darkMode: Bool = false,
        notifications: NotificationPreferences = NotificationPreferences(),
        reading: ReadingPreferences = ReadingPreferences(),
        privacy: PrivacyPreferences = PrivacyPreferences(),
        language: String = "en",
        country: String = "US",
        timezone: String = "UTC"
    ) {
        self.categories = categories
        self.sources = sources
        self.darkMode = darkMode
        self.notifications = notifications
        self.reading = reading
        self.privacy = privacy
        self.language = language
        self.country = country
        self.timezone = timezone
    }
}

// MARK: - Notification Preferences Model

/// User notification preferences
struct NotificationPreferences: Codable, Equatable {
    var pushNotifications: Bool
    var emailNotifications: Bool
    var breakingNews: Bool
    var trendingNews: Bool
    var categoryUpdates: Bool
    var weeklyDigest: Bool
    var quietHours: QuietHours?
    
    // MARK: - Initializers
    
    init(
        pushNotifications: Bool = true,
        emailNotifications: Bool = false,
        breakingNews: Bool = true,
        trendingNews: Bool = true,
        categoryUpdates: Bool = false,
        weeklyDigest: Bool = true,
        quietHours: QuietHours? = nil
    ) {
        self.pushNotifications = pushNotifications
        self.emailNotifications = emailNotifications
        self.breakingNews = breakingNews
        self.trendingNews = trendingNews
        self.categoryUpdates = categoryUpdates
        self.weeklyDigest = weeklyDigest
        self.quietHours = quietHours
    }
}

// MARK: - Quiet Hours Model

/// Quiet hours configuration for notifications
struct QuietHours: Codable, Equatable {
    var isEnabled: Bool
    var startTime: Date
    var endTime: Date
    var timezone: String
    
    // MARK: - Initializers
    
    init(
        isEnabled: Bool = false,
        startTime: Date = Calendar.current.date(from: DateComponents(hour: 22, minute: 0)) ?? Date(),
        endTime: Date = Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date(),
        timezone: String = "UTC"
    ) {
        self.isEnabled = isEnabled
        self.startTime = startTime
        self.endTime = endTime
        self.timezone = timezone
    }
    
    // MARK: - Helper Methods
    
    /// Check if current time is within quiet hours
    func isWithinQuietHours() -> Bool {
        guard isEnabled else { return false }
        
        let now = Date()
        let calendar = Calendar.current
        
        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        let currentComponents = calendar.dateComponents([.hour, .minute], from: now)
        
        let startMinutes = startComponents.hour! * 60 + startComponents.minute!
        let endMinutes = endComponents.hour! * 60 + endComponents.minute!
        let currentMinutes = currentComponents.hour! * 60 + currentComponents.minute!
        
        if startMinutes < endMinutes {
            return currentMinutes >= startMinutes && currentMinutes < endMinutes
        } else {
            return currentMinutes >= startMinutes || currentMinutes < endMinutes
        }
    }
}

// MARK: - Reading Preferences Model

/// User reading preferences and behavior settings
struct ReadingPreferences: Codable, Equatable {
    var fontSize: FontSize
    var fontFamily: FontFamily
    var lineSpacing: Double
    var autoPlay: Bool
    var offlineReading: Bool
    var readingProgress: Bool
    var nightMode: Bool
    
    // MARK: - Font Size Enum
    
    enum FontSize: String, Codable, CaseIterable {
        case small = "small"
        case medium = "medium"
        case large = "large"
        case extraLarge = "extra_large"
        
        var displayName: String {
            switch self {
            case .small: return "Small"
            case .medium: return "Medium"
            case .large: return "Large"
            case .extraLarge: return "Extra Large"
            }
        }
        
        var scale: Double {
            switch self {
            case .small: return 0.8
            case .medium: return 1.0
            case .large: return 1.2
            case .extraLarge: return 1.4
            }
        }
    }
    
    // MARK: - Font Family Enum
    
    enum FontFamily: String, Codable, CaseIterable {
        case system = "system"
        case serif = "serif"
        case sansSerif = "sans_serif"
        case monospace = "monospace"
        
        var displayName: String {
            switch self {
            case .system: return "System"
            case .serif: return "Serif"
            case .sansSerif: return "Sans Serif"
            case .monospace: return "Monospace"
            }
        }
    }
    
    // MARK: - Initializers
    
    init(
        fontSize: FontSize = .medium,
        fontFamily: FontFamily = .system,
        lineSpacing: Double = 1.2,
        autoPlay: Bool = false,
        offlineReading: Bool = true,
        readingProgress: Bool = true,
        nightMode: Bool = false
    ) {
        self.fontSize = fontSize
        self.fontFamily = fontFamily
        self.lineSpacing = lineSpacing
        self.autoPlay = autoPlay
        self.offlineReading = offlineReading
        self.readingProgress = readingProgress
        self.nightMode = nightMode
    }
}

// MARK: - Privacy Preferences Model

/// User privacy and data sharing preferences
struct PrivacyPreferences: Codable, Equatable {
    var shareUsageData: Bool
    var shareReadingHistory: Bool
    var shareLocation: Bool
    var personalizedAds: Bool
    var dataRetention: DataRetentionPeriod
    var accountVisibility: AccountVisibility
    
    // MARK: - Data Retention Period Enum
    
    enum DataRetentionPeriod: String, Codable, CaseIterable {
        case oneMonth = "1_month"
        case threeMonths = "3_months"
        case sixMonths = "6_months"
        case oneYear = "1_year"
        case indefinite = "indefinite"
        
        var displayName: String {
            switch self {
            case .oneMonth: return "1 Month"
            case .threeMonths: return "3 Months"
            case .sixMonths: return "6 Months"
            case .oneYear: return "1 Year"
            case .indefinite: return "Indefinite"
            }
        }
    }
    
    // MARK: - Account Visibility Enum
    
    enum AccountVisibility: String, Codable, CaseIterable {
        case `public` = "public"
        case friends = "friends"
        case `private` = "private"
        
        var displayName: String {
            switch self {
            case .public: return "Public"
            case .friends: return "Friends Only"
            case .private: return "Private"
            }
        }
    }
    
    // MARK: - Initializers
    
    init(
        shareUsageData: Bool = true,
        shareReadingHistory: Bool = false,
        shareLocation: Bool = false,
        personalizedAds: Bool = true,
        dataRetention: DataRetentionPeriod = .sixMonths,
        accountVisibility: AccountVisibility = .private
    ) {
        self.shareUsageData = shareUsageData
        self.shareReadingHistory = shareReadingHistory
        self.shareLocation = shareLocation
        self.personalizedAds = personalizedAds
        self.dataRetention = dataRetention
        self.accountVisibility = accountVisibility
    }
}

// MARK: - User Statistics Model

/// User activity and engagement statistics
struct UserStatistics: Codable, Equatable {
    var articlesRead: Int
    var articlesLiked: Int
    var articlesShared: Int
    var searchQueries: Int
    var timeSpentReading: TimeInterval
    var favoriteCategories: [String: Int]
    var favoriteSources: [String: Int]
    var readingStreak: Int
    var lastReadAt: Date?
    
    // MARK: - Initializers
    
    init(
        articlesRead: Int = 0,
        articlesLiked: Int = 0,
        articlesShared: Int = 0,
        searchQueries: Int = 0,
        timeSpentReading: TimeInterval = 0,
        favoriteCategories: [String: Int] = [:],
        favoriteSources: [String: Int] = [:],
        readingStreak: Int = 0,
        lastReadAt: Date? = nil
    ) {
        self.articlesRead = articlesRead
        self.articlesLiked = articlesLiked
        self.articlesShared = articlesShared
        self.searchQueries = searchQueries
        self.timeSpentReading = timeSpentReading
        self.favoriteCategories = favoriteCategories
        self.favoriteSources = favoriteSources
        self.readingStreak = readingStreak
        self.lastReadAt = lastReadAt
    }
    
    // MARK: - Helper Methods
    
    /// Get formatted time spent reading
    var formattedTimeSpentReading: String {
        let hours = Int(timeSpentReading) / 3600
        let minutes = (Int(timeSpentReading) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    /// Get top favorite category
    var topFavoriteCategory: String? {
        return favoriteCategories.max(by: { $0.value < $1.value })?.key
    }
    
    /// Get top favorite source
    var topFavoriteSource: String? {
        return favoriteSources.max(by: { $0.value < $1.value })?.key
    }
}

// MARK: - User Activity Model

/// Represents a user activity event
struct UserActivity: Identifiable, Codable, Equatable {
    let id: String
    let userId: String
    let activityType: ActivityType
    let articleId: String?
    let category: NewsCategory?
    let timestamp: Date
    let metadata: [String: String]
    
    // MARK: - Activity Type Enum
    
    enum ActivityType: String, Codable, CaseIterable {
        case articleView = "article_view"
        case articleLike = "article_like"
        case articleShare = "article_share"
        case searchQuery = "search_query"
        case categorySelect = "category_select"
        case sourceSelect = "source_select"
        case appOpen = "app_open"
        case appClose = "app_close"
        case notificationOpen = "notification_open"
        
        var displayName: String {
            switch self {
            case .articleView: return "Article View"
            case .articleLike: return "Article Like"
            case .articleShare: return "Article Share"
            case .searchQuery: return "Search Query"
            case .categorySelect: return "Category Select"
            case .sourceSelect: return "Source Select"
            case .appOpen: return "App Open"
            case .appClose: return "App Close"
            case .notificationOpen: return "Notification Open"
            }
        }
    }
    
    // MARK: - Initializers
    
    init(
        id: String = UUID().uuidString,
        userId: String,
        activityType: ActivityType,
        articleId: String? = nil,
        category: NewsCategory? = nil,
        timestamp: Date = Date(),
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.userId = userId
        self.activityType = activityType
        self.articleId = articleId
        self.category = category
        self.timestamp = timestamp
        self.metadata = metadata
    }
}

// MARK: - User Session Model

/// Represents a user session for tracking and analytics
struct UserSession: Identifiable, Codable, Equatable {
    let id: String
    let userId: String
    let startTime: Date
    let endTime: Date?
    let deviceInfo: DeviceInfo
    let appVersion: String
    let isActive: Bool
    
    // MARK: - Device Info Model
    
    struct DeviceInfo: Codable, Equatable {
        let platform: String
        let version: String
        let model: String
        let screenSize: String
        let language: String
        let timezone: String
        
        init(
            platform: String = "iOS",
            version: String = UIDevice.current.systemVersion,
            model: String = UIDevice.current.model,
            screenSize: String = "Unknown",
            language: String = Locale.current.language.languageCode?.identifier ?? "en",
            timezone: String = TimeZone.current.identifier
        ) {
            self.platform = platform
            self.version = version
            self.model = model
            self.screenSize = screenSize
            self.language = language
            self.timezone = timezone
        }
    }
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id, userId, deviceInfo, appVersion, isActive
        case startTime = "start_time"
        case endTime = "end_time"
    }
    
    // MARK: - Initializers
    
    init(
        id: String = UUID().uuidString,
        userId: String,
        startTime: Date = Date(),
        endTime: Date? = nil,
        deviceInfo: DeviceInfo = DeviceInfo(),
        appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0",
        isActive: Bool = true
    ) {
        self.id = id
        self.userId = userId
        self.startTime = startTime
        self.endTime = endTime
        self.deviceInfo = deviceInfo
        self.appVersion = appVersion
        self.isActive = isActive
    }
    
    // MARK: - Helper Methods
    
    /// Session duration in seconds
    var duration: TimeInterval? {
        guard let endTime = endTime else { return nil }
        return endTime.timeIntervalSince(startTime)
    }
    
    /// Formatted session duration
    var formattedDuration: String {
        guard let duration = duration else { return "Active" }
        
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
}

// MARK: - Extensions

extension User {
    /// Mock user for testing and previews
    static let mock = User(
        id: "mock-user-1",
        email: "john.doe@example.com",
        name: "John Doe",
        profileImageUrl: URL(string: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200"),
        preferences: UserPreferences(
            categories: [.technology, .science, .business],
            sources: [],
            darkMode: false,
            notifications: NotificationPreferences(
                pushNotifications: true,
                emailNotifications: false,
                breakingNews: true,
                trendingNews: true,
                categoryUpdates: false,
                weeklyDigest: true
            ),
            reading: ReadingPreferences(
                fontSize: .medium,
                fontFamily: .system,
                lineSpacing: 1.2,
                autoPlay: false,
                offlineReading: true,
                readingProgress: true,
                nightMode: false
            ),
            privacy: PrivacyPreferences(
                shareUsageData: true,
                shareReadingHistory: false,
                shareLocation: false,
                personalizedAds: true,
                dataRetention: .sixMonths,
                accountVisibility: .private
            ),
            language: "en",
            country: "US",
            timezone: "America/New_York"
        ),
        statistics: UserStatistics(
            articlesRead: 150,
            articlesLiked: 45,
            articlesShared: 12,
            searchQueries: 89,
            timeSpentReading: 7200, // 2 hours
            favoriteCategories: ["technology": 45, "science": 32, "business": 28],
            favoriteSources: ["TechNews": 25, "ScienceDaily": 20, "BusinessWeek": 15],
            readingStreak: 7,
            lastReadAt: Date().addingTimeInterval(-3600)
        ),
        createdAt: Date().addingTimeInterval(-86400 * 30), // 30 days ago
        lastActiveAt: Date().addingTimeInterval(-300), // 5 minutes ago
        isEmailVerified: true,
        isPremium: false
    )
}

extension UserPreferences {
    /// Check if user has any categories selected
    var hasCategories: Bool {
        return !categories.isEmpty
    }
    
    /// Check if user has any sources selected
    var hasSources: Bool {
        return !sources.isEmpty
    }
    
    /// Get selected category IDs
    var categoryIds: [String] {
        return categories.map { $0.id }
    }
    
    /// Get selected source IDs
    var sourceIds: [String] {
        return sources.map { $0.id }
    }
}

// MARK: - Data Type Enum

/// Data types for user data export and management
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
