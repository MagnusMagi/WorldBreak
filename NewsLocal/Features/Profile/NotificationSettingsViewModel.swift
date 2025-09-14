//
//  NotificationSettingsViewModel.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import SwiftUI
import UserNotifications

/// ViewModel for managing notification settings
@MainActor
class NotificationSettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var pushNotifications: Bool = true
    @Published var emailNotifications: Bool = false
    @Published var breakingNews: Bool = true
    @Published var trendingNews: Bool = true
    @Published var categoryUpdates: Bool = false
    @Published var weeklyDigest: Bool = true
    @Published var quietHoursEnabled: Bool = false
    @Published var quietHoursStart: Date = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date()) ?? Date()
    @Published var quietHoursEnd: Date = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date()
    @Published var notificationFrequency: NotificationFrequency = .immediate
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccessMessage: Bool = false
    
    // MARK: - Private Properties
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Initialization
    
    init() {
        loadSettings()
    }
    
    // MARK: - Public Methods
    
    /// Load notification settings from UserDefaults
    func loadSettings() {
        pushNotifications = UserDefaults.standard.bool(forKey: "pushNotifications")
        emailNotifications = UserDefaults.standard.bool(forKey: "emailNotifications")
        breakingNews = UserDefaults.standard.bool(forKey: "breakingNews")
        trendingNews = UserDefaults.standard.bool(forKey: "trendingNews")
        categoryUpdates = UserDefaults.standard.bool(forKey: "categoryUpdates")
        weeklyDigest = UserDefaults.standard.bool(forKey: "weeklyDigest")
        quietHoursEnabled = UserDefaults.standard.bool(forKey: "quietHoursEnabled")
        
        if let startTime = UserDefaults.standard.object(forKey: "quietHoursStart") as? Date {
            quietHoursStart = startTime
        }
        
        if let endTime = UserDefaults.standard.object(forKey: "quietHoursEnd") as? Date {
            quietHoursEnd = endTime
        }
        
        if let frequency = UserDefaults.standard.string(forKey: "notificationFrequency"),
           let frequencyEnum = NotificationFrequency(rawValue: frequency) {
            notificationFrequency = frequencyEnum
        }
    }
    
    /// Save notification settings to UserDefaults
    func saveSettings() {
        UserDefaults.standard.set(pushNotifications, forKey: "pushNotifications")
        UserDefaults.standard.set(emailNotifications, forKey: "emailNotifications")
        UserDefaults.standard.set(breakingNews, forKey: "breakingNews")
        UserDefaults.standard.set(trendingNews, forKey: "trendingNews")
        UserDefaults.standard.set(categoryUpdates, forKey: "categoryUpdates")
        UserDefaults.standard.set(weeklyDigest, forKey: "weeklyDigest")
        UserDefaults.standard.set(quietHoursEnabled, forKey: "quietHoursEnabled")
        UserDefaults.standard.set(quietHoursStart, forKey: "quietHoursStart")
        UserDefaults.standard.set(quietHoursEnd, forKey: "quietHoursEnd")
        UserDefaults.standard.set(notificationFrequency.rawValue, forKey: "notificationFrequency")
        
        // Update notification permissions
        updateNotificationPermissions()
        
        showSuccessMessage = true
    }
    
    /// Send a test notification
    func sendTestNotification() {
        guard pushNotifications else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification from NewsLocal"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "test-notification",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Failed to send test notification: \(error.localizedDescription)"
                } else {
                    self.showSuccessMessage = true
                }
            }
        }
    }
    
    /// Request notification permissions
    func requestNotificationPermissions() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.pushNotifications = true
                } else {
                    self.pushNotifications = false
                    self.errorMessage = "Notification permission denied"
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func updateNotificationPermissions() {
        if pushNotifications {
            requestNotificationPermissions()
        } else {
            // Disable all notifications
            notificationCenter.removeAllPendingNotificationRequests()
        }
    }
}

// MARK: - Extensions

extension NotificationSettingsViewModel {
    /// Mock data for previews
    static let mock = NotificationSettingsViewModel()
}
