//
//  Date+Extensions.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation

// MARK: - Date Extensions

extension Date {
    
    // MARK: - Formatters
    
    /// ISO 8601 formatter for API communication
    static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    /// Standard date formatter for display
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    /// Short date formatter for compact display
    static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    /// Time-only formatter
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeStyle = .short
        return formatter
    }()
    
    /// Relative date formatter for "time ago" display
    static let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale.current
        return formatter
    }()
    
    // MARK: - String Representations
    
    /// ISO 8601 string representation
    var iso8601String: String {
        return Date.iso8601Formatter.string(from: self)
    }
    
    /// Display string for UI
    var displayString: String {
        return Date.displayFormatter.string(from: self)
    }
    
    /// Short date string
    var shortDateString: String {
        return Date.shortFormatter.string(from: self)
    }
    
    /// Time-only string
    var timeString: String {
        return Date.timeFormatter.string(from: self)
    }
    
    /// Relative time string (e.g., "2 hours ago")
    var relativeTimeString: String {
        return Date.relativeFormatter.localizedString(for: self, relativeTo: Date())
    }
    
    /// Smart relative time string with fallback
    var smartRelativeString: String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(self)
        
        // Less than 1 minute
        if timeInterval < 60 {
            return "Just now"
        }
        
        // Less than 1 hour
        if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        }
        
        // Less than 24 hours
        if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        }
        
        // Less than 7 days
        if timeInterval < 604800 {
            let days = Int(timeInterval / 86400)
            return "\(days) day\(days == 1 ? "" : "s") ago"
        }
        
        // More than 7 days - show actual date
        return shortDateString
    }
    
    // MARK: - Date Components
    
    /// Year component
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    /// Month component
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    /// Day component
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    /// Hour component
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    /// Minute component
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    /// Second component
    var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    /// Weekday component (1 = Sunday, 7 = Saturday)
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    /// Week of year
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    /// Day of year
    var dayOfYear: Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: self) ?? 0
    }
    
    // MARK: - Date Calculations
    
    /// Start of day
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// End of day
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
    
    /// Start of week
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// End of week
    var endOfWeek: Date {
        let calendar = Calendar.current
        let startOfWeek = self.startOfWeek
        var components = DateComponents()
        components.day = 7
        components.second = -1
        return calendar.date(byAdding: components, to: startOfWeek) ?? self
    }
    
    /// Start of month
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// End of month
    var endOfMonth: Date {
        let calendar = Calendar.current
        let startOfMonth = self.startOfMonth
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfMonth) ?? self
    }
    
    /// Start of year
    var startOfYear: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// End of year
    var endOfYear: Date {
        let calendar = Calendar.current
        let startOfYear = self.startOfYear
        var components = DateComponents()
        components.year = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfYear) ?? self
    }
    
    // MARK: - Date Comparisons
    
    /// Check if date is today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Check if date is yesterday
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// Check if date is tomorrow
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// Check if date is in current week
    var isThisWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    /// Check if date is in current month
    var isThisMonth: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    /// Check if date is in current year
    var isThisYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    /// Check if date is weekend
    var isWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    
    /// Check if date is weekday
    var isWeekday: Bool {
        return !isWeekend
    }
    
    // MARK: - Date Arithmetic
    
    /// Add days to date
    func addingDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    /// Add hours to date
    func addingHours(_ hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self) ?? self
    }
    
    /// Add minutes to date
    func addingMinutes(_ minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self) ?? self
    }
    
    /// Add seconds to date
    func addingSeconds(_ seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self) ?? self
    }
    
    /// Add months to date
    func addingMonths(_ months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }
    
    /// Add years to date
    func addingYears(_ years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self) ?? self
    }
    
    /// Subtract days from date
    func subtractingDays(_ days: Int) -> Date {
        return addingDays(-days)
    }
    
    /// Subtract hours from date
    func subtractingHours(_ hours: Int) -> Date {
        return addingHours(-hours)
    }
    
    /// Subtract minutes from date
    func subtractingMinutes(_ minutes: Int) -> Date {
        return addingMinutes(-minutes)
    }
    
    /// Subtract seconds from date
    func subtractingSeconds(_ seconds: Int) -> Date {
        return addingSeconds(-seconds)
    }
    
    /// Subtract months from date
    func subtractingMonths(_ months: Int) -> Date {
        return addingMonths(-months)
    }
    
    /// Subtract years from date
    func subtractingYears(_ years: Int) -> Date {
        return addingYears(-years)
    }
    
    // MARK: - Time Intervals
    
    /// Time interval since date in days
    func daysSince(_ date: Date) -> Int {
        let timeInterval = timeIntervalSince(date)
        return Int(timeInterval / 86400)
    }
    
    /// Time interval since date in hours
    func hoursSince(_ date: Date) -> Int {
        let timeInterval = timeIntervalSince(date)
        return Int(timeInterval / 3600)
    }
    
    /// Time interval since date in minutes
    func minutesSince(_ date: Date) -> Int {
        let timeInterval = timeIntervalSince(date)
        return Int(timeInterval / 60)
    }
    
    /// Time interval since date in seconds
    func secondsSince(_ date: Date) -> Int {
        return Int(timeIntervalSince(date))
    }
    
    // MARK: - Date Formatting
    
    /// Format date with custom format
    func formatted(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    /// Format date for API requests
    func formattedForAPI() -> String {
        return iso8601String
    }
    
    /// Format date for display with smart formatting
    func formattedForDisplay() -> String {
        if isToday {
            return "Today, \(timeString)"
        } else if isYesterday {
            return "Yesterday, \(timeString)"
        } else if isThisWeek {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, \(timeString)"
            return formatter.string(from: self)
        } else if isThisYear {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, \(timeString)"
            return formatter.string(from: self)
        } else {
            return displayString
        }
    }
    
    // MARK: - Static Methods
    
    /// Create date from ISO 8601 string
    static func fromISO8601(_ string: String) -> Date? {
        return iso8601Formatter.date(from: string)
    }
    
    /// Create date from components
    static func from(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        return Calendar.current.date(from: components)
    }
    
    /// Get current timestamp in milliseconds
    static var currentTimestamp: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    /// Get current timestamp in seconds
    static var currentTimestampSeconds: Int64 {
        return Int64(Date().timeIntervalSince1970)
    }
    
    // MARK: - Age Calculations
    
    /// Calculate age in years
    var ageInYears: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
    
    /// Calculate age in months
    var ageInMonths: Int {
        return Calendar.current.dateComponents([.month], from: self, to: Date()).month ?? 0
    }
    
    /// Calculate age in days
    var ageInDays: Int {
        return Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
    }
    
    // MARK: - Business Logic
    
    /// Check if date is within business hours (9 AM - 5 PM)
    var isBusinessHours: Bool {
        let hour = self.hour
        return hour >= 9 && hour < 17 && isWeekday
    }
    
    /// Get next business day
    var nextBusinessDay: Date {
        var date = addingDays(1)
        while date.isWeekend {
            date = date.addingDays(1)
        }
        return date
    }
    
    /// Get previous business day
    var previousBusinessDay: Date {
        var date = subtractingDays(1)
        while date.isWeekend {
            date = date.subtractingDays(1)
        }
        return date
    }
    
    // MARK: - News Specific
    
    /// Check if article is recent (published within last 24 hours)
    var isRecent: Bool {
        return timeIntervalSinceNow > -86400 // 24 hours in seconds
    }
    
    /// Check if article is fresh (published within last hour)
    var isFresh: Bool {
        return timeIntervalSinceNow > -3600 // 1 hour in seconds
    }
    
    /// Get reading time category
    var readingTimeCategory: String {
        let hours = abs(timeIntervalSinceNow) / 3600
        
        if hours < 1 {
            return "Just now"
        } else if hours < 24 {
            return "Today"
        } else if hours < 168 { // 7 days
            return "This week"
        } else if hours < 720 { // 30 days
            return "This month"
        } else {
            return "Older"
        }
    }
}

// MARK: - Date Range Extensions

extension Date {
    
    /// Create date range from start to end
    static func range(from start: Date, to end: Date) -> ClosedRange<Date> {
        return start...end
    }
    
    /// Check if date is within range
    func isWithin(_ range: ClosedRange<Date>) -> Bool {
        return range.contains(self)
    }
    
    /// Get days between two dates
    static func daysBetween(_ start: Date, and end: Date) -> Int {
        return start.daysSince(end)
    }
    
    /// Get hours between two dates
    static func hoursBetween(_ start: Date, and end: Date) -> Int {
        return start.hoursSince(end)
    }
    
    /// Get minutes between two dates
    static func minutesBetween(_ start: Date, and end: Date) -> Int {
        return start.minutesSince(end)
    }
}

// MARK: - Date Array Extensions

extension Array where Element == Date {
    
    /// Sort dates in ascending order
    var sortedAscending: [Date] {
        return sorted { $0 < $1 }
    }
    
    /// Sort dates in descending order
    var sortedDescending: [Date] {
        return sorted { $0 > $1 }
    }
    
    /// Get earliest date
    var earliest: Date? {
        return sortedAscending.first
    }
    
    /// Get latest date
    var latest: Date? {
        return sortedDescending.first
    }
    
    /// Get dates within range
    func within(_ range: ClosedRange<Date>) -> [Date] {
        return filter { $0.isWithin(range) }
    }
    
    /// Get unique dates (same day)
    var uniqueDates: [Date] {
        let calendar = Calendar.current
        let uniqueDays = Set(map { calendar.startOfDay(for: $0) })
        return Array(uniqueDays).sorted()
    }
}
