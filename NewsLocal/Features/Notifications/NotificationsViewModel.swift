//
//  NotificationsViewModel.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel for NotificationsView managing notification settings and history
@MainActor
class NotificationsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    // Push Notifications
    @Published var breakingNewsEnabled: Bool = true
    @Published var dailyDigestEnabled: Bool = false
    @Published var trendingEnabled: Bool = true
    
    // Email Notifications
    @Published var weeklyNewsletterEnabled: Bool = true
    @Published var productUpdatesEnabled: Bool = false
    
    // Quiet Hours
    @Published var quietHoursEnabled: Bool = false
    @Published var quietHoursStart: Date = Calendar.current.date(from: DateComponents(hour: 22, minute: 0)) ?? Date()
    @Published var quietHoursEnd: Date = Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? Date()
    
    // Notification History
    @Published var recentNotifications: [NotificationItem] = []
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Initialization
    
    init() {
        loadSettings()
        generateMockNotifications()
        setupObservers()
    }
    
    // MARK: - Public Methods
    
    /// Save all notification settings
    func saveSettings() {
        userDefaults.set(breakingNewsEnabled, forKey: "breakingNewsEnabled")
        userDefaults.set(dailyDigestEnabled, forKey: "dailyDigestEnabled")
        userDefaults.set(trendingEnabled, forKey: "trendingEnabled")
        userDefaults.set(weeklyNewsletterEnabled, forKey: "weeklyNewsletterEnabled")
        userDefaults.set(productUpdatesEnabled, forKey: "productUpdatesEnabled")
        userDefaults.set(quietHoursEnabled, forKey: "quietHoursEnabled")
        userDefaults.set(quietHoursStart, forKey: "quietHoursStart")
        userDefaults.set(quietHoursEnd, forKey: "quietHoursEnd")
    }
    
    /// Clear all notification history
    func clearNotificationHistory() {
        recentNotifications.removeAll()
    }
    
    // MARK: - Private Methods
    
    /// Load settings from UserDefaults
    private func loadSettings() {
        breakingNewsEnabled = userDefaults.bool(forKey: "breakingNewsEnabled")
        dailyDigestEnabled = userDefaults.bool(forKey: "dailyDigestEnabled")
        trendingEnabled = userDefaults.bool(forKey: "trendingEnabled")
        weeklyNewsletterEnabled = userDefaults.bool(forKey: "weeklyNewsletterEnabled")
        productUpdatesEnabled = userDefaults.bool(forKey: "productUpdatesEnabled")
        quietHoursEnabled = userDefaults.bool(forKey: "quietHoursEnabled")
        
        if let startDate = userDefaults.object(forKey: "quietHoursStart") as? Date {
            quietHoursStart = startDate
        }
        
        if let endDate = userDefaults.object(forKey: "quietHoursEnd") as? Date {
            quietHoursEnd = endDate
        }
    }
    
    /// Setup observers for automatic saving
    private func setupObservers() {
        Publishers.Merge4(
            $breakingNewsEnabled,
            $dailyDigestEnabled,
            $trendingEnabled,
            $weeklyNewsletterEnabled
        )
        .sink { [weak self] _ in
            self?.saveSettings()
        }
        .store(in: &cancellables)
        
        $productUpdatesEnabled
            .sink { [weak self] _ in
                self?.saveSettings()
            }
            .store(in: &cancellables)
        
        $quietHoursEnabled
            .sink { [weak self] _ in
                self?.saveSettings()
            }
            .store(in: &cancellables)
        
        Publishers.Merge($quietHoursStart, $quietHoursEnd)
            .sink { [weak self] _ in
                self?.saveSettings()
            }
            .store(in: &cancellables)
    }
    
    /// Generate mock notification history for demo
    private func generateMockNotifications() {
        let calendar = Calendar.current
        let now = Date()
        
        recentNotifications = [
            NotificationItem(
                id: "1",
                title: "Breaking News",
                message: "Major technology breakthrough announced",
                icon: "bolt.fill",
                color: .red,
                timestamp: calendar.date(byAdding: .minute, value: -5, to: now) ?? now
            ),
            NotificationItem(
                id: "2",
                title: "Daily Digest",
                message: "Your daily news summary is ready",
                icon: "newspaper.fill",
                color: .blue,
                timestamp: calendar.date(byAdding: .hour, value: -2, to: now) ?? now
            ),
            NotificationItem(
                id: "3",
                title: "Trending Topic",
                message: "Climate change discussions trending",
                icon: "flame.fill",
                color: .orange,
                timestamp: calendar.date(byAdding: .hour, value: -4, to: now) ?? now
            ),
            NotificationItem(
                id: "4",
                title: "Weekly Newsletter",
                message: "Your weekly newsletter has been sent",
                icon: "envelope.fill",
                color: .green,
                timestamp: calendar.date(byAdding: .day, value: -1, to: now) ?? now
            ),
            NotificationItem(
                id: "5",
                title: "Product Update",
                message: "New features added to the app",
                icon: "star.fill",
                color: .purple,
                timestamp: calendar.date(byAdding: .day, value: -2, to: now) ?? now
            )
        ]
    }
}

// MARK: - Notification Item Model

struct NotificationItem: Identifiable {
    let id: String
    let title: String
    let message: String
    let icon: String
    let color: Color
    let timestamp: Date
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
