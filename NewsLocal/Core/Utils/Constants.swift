//
//  Constants.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - App Constants

/// Centralized constants for the NewsLocal application
struct Constants {
    
    // MARK: - App Information
    
    struct App {
        static let name = "NewsLocal"
        static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.newslocal.app"
        static let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "NewsLocal"
    }
    
    // MARK: - API Configuration
    
    struct API {
        static let baseURL = "http://localhost:3000/api/v1"
        static let apiBaseURL = "http://localhost:3000/api/v1"
        static let networkTimeout: TimeInterval = 30.0
        static let networkRetryCount = 3
        static let retryDelay: TimeInterval = 1.0
        
        // News API
        static let newsAPIKey = "your_news_api_key_here"
        static let newsAPIBaseURL = "https://newsapi.org/v2"
        static let newsAPITimeout: TimeInterval = 15.0
        
        // Real-time
        static let websocketURL = "wss://api.newslocal.com/ws"
        static let websocketTimeout: TimeInterval = 10.0
        static let websocketReconnectInterval: TimeInterval = 5.0
        static let websocketMaxReconnectAttempts = 5
    }
    
    // MARK: - Storage Keys
    
    struct StorageKeys {
        // User Data
        static let userToken = "user_token"
        static let userRefreshToken = "user_refresh_token"
        static let currentUser = "current_user"
        static let userPreferences = "user_preferences"
        
        // App State
        static let lastSyncDate = "last_sync_date"
        static let onboardingCompleted = "onboarding_completed"
        static let appLaunchCount = "app_launch_count"
        static let lastAppVersion = "last_app_version"
        
        // Cache
        static let cachedArticles = "cached_articles"
        static let cachedCategories = "cached_categories"
        static let cachedSources = "cached_sources"
        static let cacheTimestamp = "cache_timestamp"
        
        // Settings
        static let darkModeEnabled = "dark_mode_enabled"
        static let notificationsEnabled = "notifications_enabled"
        static let analyticsEnabled = "analytics_enabled"
        static let crashReportingEnabled = "crash_reporting_enabled"
        
        // Offline
        static let offlineArticles = "offline_articles"
        static let offlineReadingList = "offline_reading_list"
        static let lastOfflineSync = "last_offline_sync"
    }
    
    // MARK: - Cache Configuration
    
    struct Cache {
        static let maxAge: TimeInterval = 3600 // 1 hour
        static let maxSize: Int = 100 * 1024 * 1024 // 100 MB
        static let maxArticles = 1000
        static let maxImages = 500
        static let compressionQuality: CGFloat = 0.8
        
        // Cache directories
        static let articlesDirectory = "articles"
        static let imagesDirectory = "images"
        static let thumbnailsDirectory = "thumbnails"
        static let userDataDirectory = "user_data"
    }
    
    // MARK: - UI Constants
    
    struct UI {
        // Layout
        static let cornerRadius: CGFloat = 12.0
        static let borderWidth: CGFloat = 1.0
        static let shadowRadius: CGFloat = 4.0
        static let shadowOpacity: Float = 0.1
        
        // Spacing
        static let paddingXS: CGFloat = 4.0
        static let paddingSM: CGFloat = 8.0
        static let paddingMD: CGFloat = 16.0
        static let paddingLG: CGFloat = 24.0
        static let paddingXL: CGFloat = 32.0
        static let paddingXXL: CGFloat = 48.0
        
        // Enum types for View+Extensions
        enum Padding: CGFloat, CaseIterable {
            case xs = 4.0
            case sm = 8.0
            case md = 16.0
            case lg = 24.0
            case xl = 32.0
            case xxl = 48.0
        }
        
        enum CornerRadius: CGFloat, CaseIterable {
            case small = 8.0
            case medium = 12.0
            case large = 16.0
            case extraLarge = 20.0
        }
        
        enum Shadow: CaseIterable {
            case small
            case medium
            case large
            
            var radius: CGFloat {
                switch self {
                case .small: return 2.0
                case .medium: return 4.0
                case .large: return 8.0
                }
            }
            
            var opacity: Float {
                switch self {
                case .small: return 0.05
                case .medium: return 0.1
                case .large: return 0.15
                }
            }
        }
        
        // Sizes
        static let buttonHeight: CGFloat = 44.0
        static let textFieldHeight: CGFloat = 44.0
        static let tabBarHeight: CGFloat = 83.0
        static let navigationBarHeight: CGFloat = 44.0
        
        // Animation
        static let animationDuration: Double = 0.3
        static let springAnimation = Animation.spring(response: 0.5, dampingFraction: 0.8)
        static let easeInOutAnimation = Animation.easeInOut(duration: animationDuration)
        
        // Grid
        static let gridColumns = 2
        static let gridSpacing: CGFloat = 16.0
        static let gridItemAspectRatio: CGFloat = 1.2
    }
    
    // MARK: - Typography
    
    struct Typography {
        // Font sizes
        static let headline: CGFloat = 28.0
        static let title: CGFloat = 22.0
        static let body: CGFloat = 17.0
        static let callout: CGFloat = 16.0
        static let subheadline: CGFloat = 15.0
        static let footnote: CGFloat = 13.0
        static let caption: CGFloat = 12.0
        static let caption2: CGFloat = 11.0
        
        // Line heights
        static let headlineLineHeight: CGFloat = 34.0
        static let titleLineHeight: CGFloat = 28.0
        static let bodyLineHeight: CGFloat = 22.0
        static let calloutLineHeight: CGFloat = 21.0
        static let subheadlineLineHeight: CGFloat = 20.0
        static let footnoteLineHeight: CGFloat = 18.0
        static let captionLineHeight: CGFloat = 16.0
        static let caption2LineHeight: CGFloat = 13.0
        
        // Font weights
        static let lightWeight: Font.Weight = .light
        static let regularWeight: Font.Weight = .regular
        static let mediumWeight: Font.Weight = .medium
        static let semiboldWeight: Font.Weight = .semibold
        static let boldWeight: Font.Weight = .bold
        static let heavyWeight: Font.Weight = .heavy
    }
    
    // MARK: - Colors
    
    struct Colors {
        // Primary colors
        static let primary = Color(red: 0.0, green: 0.48, blue: 1.0) // iOS Blue
        static let primaryDark = Color(red: 0.0, green: 0.35, blue: 0.8)
        static let secondary = Color(red: 0.35, green: 0.34, blue: 0.84) // iOS Purple
        
        // Semantic colors
        static let success = Color(red: 0.20, green: 0.78, blue: 0.35) // iOS Green
        static let warning = Color(red: 1.0, green: 0.58, blue: 0.0) // iOS Orange
        static let error = Color(red: 1.0, green: 0.23, blue: 0.19) // iOS Red
        static let info = Color(red: 0.0, green: 0.48, blue: 1.0) // iOS Blue
        
        // Neutral colors
        static let background = Color(.systemBackground)
        static let secondaryBackground = Color(.secondarySystemBackground)
        static let tertiaryBackground = Color(.tertiarySystemBackground)
        static let label = Color(.label)
        static let secondaryLabel = Color(.secondaryLabel)
        static let tertiaryLabel = Color(.tertiaryLabel)
        static let placeholderText = Color(.placeholderText)
        static let separator = Color(.separator)
        static let opaqueSeparator = Color(.opaqueSeparator)
        
        // Category colors
        static let categoryGeneral = Color.gray
        static let categoryBusiness = Color.blue
        static let categoryTechnology = Color.purple
        static let categoryScience = Color.green
        static let categoryHealth = Color.red
        static let categorySports = Color.orange
        static let categoryEntertainment = Color.pink
        static let categoryPolitics = Color.indigo
        static let categoryWorld = Color.teal
        static let categoryLocal = Color.mint
    }
    
    // MARK: - Images
    
    struct Images {
        // System icons
        static let heart = "heart"
        static let heartFill = "heart.fill"
        static let bookmark = "bookmark"
        static let bookmarkFill = "bookmark.fill"
        static let share = "square.and.arrow.up"
        static let search = "magnifyingglass"
        static let filter = "line.3.horizontal.decrease.circle"
        static let settings = "gear"
        static let profile = "person.circle"
        static let notification = "bell"
        static let notificationFill = "bell.fill"
        
        // Navigation icons
        static let home = "house"
        static let homeFill = "house.fill"
        static let categories = "list.bullet"
        static let categoriesFill = "list.bullet.rectangle"
        static let searchTab = "magnifyingglass.circle"
        static let searchTabFill = "magnifyingglass.circle.fill"
        static let profileTab = "person.crop.circle"
        static let profileTabFill = "person.crop.circle.fill"
        
        // Content icons
        static let breakingNews = "exclamationmark.triangle.fill"
        static let trending = "flame.fill"
        static let new = "sparkles"
        static let popular = "star.fill"
        static let recent = "clock.fill"
        static let recommended = "hand.thumbsup.fill"
        
        // Category icons
        static let categoryGeneral = "newspaper"
        static let categoryBusiness = "briefcase"
        static let categoryTechnology = "laptopcomputer"
        static let categoryScience = "atom"
        static let categoryHealth = "heart.fill"
        static let categorySports = "sportscourt"
        static let categoryEntertainment = "tv"
        static let categoryPolitics = "building.2"
        static let categoryWorld = "globe"
        static let categoryLocal = "location"
        
        // UI icons
        static let chevronRight = "chevron.right"
        static let chevronLeft = "chevron.left"
        static let chevronUp = "chevron.up"
        static let chevronDown = "chevron.down"
        static let xmark = "xmark"
        static let checkmark = "checkmark"
        static let plus = "plus"
        static let minus = "minus"
        static let ellipsis = "ellipsis"
        static let info = "info.circle"
        static let warning = "exclamationmark.triangle"
        static let error = "xmark.circle"
        static let success = "checkmark.circle"
    }
    
    // MARK: - Notifications
    
    struct Notifications {
        // Notification categories
        static let breakingNews = "BREAKING_NEWS"
        static let trendingNews = "TRENDING_NEWS"
        static let categoryUpdate = "CATEGORY_UPDATE"
        static let weeklyDigest = "WEEKLY_DIGEST"
        static let systemUpdate = "SYSTEM_UPDATE"
        
        // Notification actions
        static let readAction = "READ_ACTION"
        static let shareAction = "SHARE_ACTION"
        static let bookmarkAction = "BOOKMARK_ACTION"
        static let dismissAction = "DISMISS_ACTION"
        
        // Notification intervals
        static let immediateDelivery = "immediate"
        static let hourlyDelivery = "hourly"
        static let dailyDelivery = "daily"
        static let weeklyDelivery = "weekly"
    }
    
    // MARK: - Analytics
    
    struct Analytics {
        // Event names
        static let appLaunch = "app_launch"
        static let appBackground = "app_background"
        static let appForeground = "app_foreground"
        static let userLogin = "user_login"
        static let userLogout = "user_logout"
        static let articleView = "article_view"
        static let articleLike = "article_like"
        static let articleShare = "article_share"
        static let articleBookmark = "article_bookmark"
        static let searchQuery = "search_query"
        static let categorySelect = "category_select"
        static let notificationReceived = "notification_received"
        static let notificationTapped = "notification_tapped"
        
        // User properties
        static let userID = "user_id"
        static let userEmail = "user_email"
        static let userPlan = "user_plan"
        static let appVersion = "app_version"
        static let deviceModel = "device_model"
        static let osVersion = "os_version"
        
        // Custom dimensions
        static let articleCategory = "article_category"
        static let articleSource = "article_source"
        static let articleReadingTime = "article_reading_time"
        static let searchResults = "search_results"
        static let sessionDuration = "session_duration"
    }
    
    // MARK: - Feature Flags
    
    struct FeatureFlags {
        static let realTimeUpdates = "real_time_updates"
        static let offlineReading = "offline_reading"
        static let pushNotifications = "push_notifications"
        static let socialSharing = "social_sharing"
        static let darkMode = "dark_mode"
        static let biometricAuth = "biometric_auth"
        static let personalizedRecommendations = "personalized_recommendations"
        static let advancedSearch = "advanced_search"
        static let voiceSearch = "voice_search"
        static let widget = "widget"
        static let appleWatch = "apple_watch"
        static let siriShortcuts = "siri_shortcuts"
    }
    
    // MARK: - Limits
    
    struct Limits {
        // API limits
        static let maxArticlesPerRequest = 100
        static let maxSearchResults = 1000
        static let maxBookmarks = 10000
        static let maxOfflineArticles = 500
        
        // UI limits
        static let maxCharactersInSearch = 100
        static let maxCharactersInComment = 500
        static let maxImageSize = 10 * 1024 * 1024 // 10 MB
        static let maxCacheSize = 100 * 1024 * 1024 // 100 MB
        
        // Rate limits
        static let maxAPIRequestsPerMinute = 60
        static let maxSearchRequestsPerMinute = 30
        static let maxLikeRequestsPerMinute = 10
        static let maxShareRequestsPerMinute = 5
    }
    
    // MARK: - Timeouts
    
    struct Timeouts {
        // Network timeouts
        static let apiRequest: TimeInterval = 30.0
        static let imageDownload: TimeInterval = 15.0
        static let websocketConnection: TimeInterval = 10.0
        static let pushNotification: TimeInterval = 5.0
        
        // UI timeouts
        static let splashScreen: TimeInterval = 2.0
        static let loadingIndicator: TimeInterval = 3.0
        static let toastMessage: TimeInterval = 3.0
        static let errorMessage: TimeInterval = 5.0
        
        // Cache timeouts
        static let articleCache: TimeInterval = 3600 // 1 hour
        static let imageCache: TimeInterval = 86400 // 24 hours
        static let userDataCache: TimeInterval = 1800 // 30 minutes
        static let searchCache: TimeInterval = 300 // 5 minutes
    }
    
    // MARK: - URLs
    
    struct URLs {
        // App Store
        static let appStore = "https://apps.apple.com/app/newslocal/id123456789"
        static let appStoreReview = "https://apps.apple.com/app/newslocal/id123456789?action=write-review"
        
        // Support
        static let support = "https://support.newslocal.com"
        static let privacy = "https://newslocal.com/privacy"
        static let terms = "https://newslocal.com/terms"
        static let feedback = "https://newslocal.com/feedback"
        
        // Social media
        static let twitter = "https://twitter.com/newslocal"
        static let facebook = "https://facebook.com/newslocal"
        static let instagram = "https://instagram.com/newslocal"
        static let linkedin = "https://linkedin.com/company/newslocal"
        
        // Documentation
        static let apiDocs = "https://api.newslocal.com/docs"
        static let developerDocs = "https://developers.newslocal.com"
        static let statusPage = "https://status.newslocal.com"
    }
    
    // MARK: - Environment
    
    struct Environment {
        static let isDebug = _isDebugAssertConfiguration()
        // TODO: Update to use StoreKit 2 - AppTransaction.shared
        static let isTestFlight = false // Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
        static let isAppStore = false // Bundle.main.appStoreReceiptURL?.lastPathComponent == "receipt"
        static let isSimulator: Bool = {
            #if targetEnvironment(simulator)
            return true
            #else
            return false
            #endif
        }()
        
        // Build configuration
        static let configuration: String = {
            #if DEBUG
            return "Debug"
            #elseif STAGING
            return "Staging"
            #else
            return "Release"
            #endif
        }()
    }
}

// MARK: - Device Information

struct DeviceInfo {
    static let model = UIDevice.current.model
    static let systemName = UIDevice.current.systemName
    static let systemVersion = UIDevice.current.systemVersion
    static let deviceName = UIDevice.current.name
    static let identifierForVendor = UIDevice.current.identifierForVendor?.uuidString
    
    // Screen information
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let screenScale = UIScreen.main.scale
    static let screenBrightness = UIScreen.main.brightness
    
    // Device capabilities
    static let hasHapticFeedback = UIDevice.current.userInterfaceIdiom == .phone
    static let hasBiometrics = true // Would check actual biometric capability
    static let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
    static let hasMicrophone = true // Would check actual microphone capability
    
    // Network information
    static let isConnectedToInternet: Bool = {
        // Would implement actual network connectivity check
        return true
    }()
    
    static let connectionType: String = {
        // Would determine actual connection type (WiFi, Cellular, etc.)
        return "WiFi"
    }()
}

// MARK: - Localization

struct Localization {
    static let currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"
    static let currentRegion = Locale.current.region?.identifier ?? "US"
    static let currentLocale = Locale.current.identifier
    static let uses24HourFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)?.contains("a") == false
    static let preferredLanguages = Locale.preferredLanguages
    
    // Date and time formatting
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeStyle = .short
        return formatter
    }()
    
    // Number formatting
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        return formatter
    }()
}

// MARK: - Accessibility

struct Accessibility {
    static let isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
    static let isSwitchControlRunning = UIAccessibility.isSwitchControlRunning
    static let isAssistiveTouchRunning = UIAccessibility.isAssistiveTouchRunning
    static let isReduceMotionEnabled = UIAccessibility.isReduceMotionEnabled
    static let isReduceTransparencyEnabled = UIAccessibility.isReduceTransparencyEnabled
    static let isBoldTextEnabled = UIAccessibility.isBoldTextEnabled
    static let isGrayscaleEnabled = UIAccessibility.isGrayscaleEnabled
    static let isInvertColorsEnabled = UIAccessibility.isInvertColorsEnabled
    
    // Dynamic Type
    static let preferredContentSizeCategory = UIApplication.shared.preferredContentSizeCategory
    static let isLargeTextEnabled = preferredContentSizeCategory.isAccessibilityCategory
    
    // Accessibility labels
    static let accessibilityLabels = [
        "search": "Search articles",
        "filter": "Filter articles",
        "bookmark": "Bookmark article",
        "share": "Share article",
        "like": "Like article",
        "read": "Mark as read",
        "settings": "Settings",
        "profile": "User profile",
        "notifications": "Notifications",
        "categories": "News categories"
    ]
}

// MARK: - Performance

struct Performance {
    // Memory limits
    static let maxMemoryUsage: UInt64 = 100 * 1024 * 1024 // 100 MB
    static let memoryWarningThreshold: UInt64 = 80 * 1024 * 1024 // 80 MB
    
    // CPU limits
    static let maxCPUUsage: Double = 80.0 // 80%
    static let cpuWarningThreshold: Double = 70.0 // 70%
    
    // Battery optimization
    static let lowPowerModeEnabled = ProcessInfo.processInfo.isLowPowerModeEnabled
    static let thermalState = ProcessInfo.processInfo.thermalState
    
    // Background processing
    static let backgroundTimeRemaining = UIApplication.shared.backgroundTimeRemaining
    static let applicationState = UIApplication.shared.applicationState
    
    // Performance monitoring
    static let shouldMonitorPerformance: Bool = {
        return !Constants.Environment.isDebug && !Constants.Environment.isSimulator
    }()
}
