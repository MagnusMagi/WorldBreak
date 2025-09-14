//
//  PrivacySettingsViewModel.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import SwiftUI

/// ViewModel for privacy and data settings
@MainActor
class PrivacySettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var shareUsageData: Bool = true
    @Published var shareReadingHistory: Bool = false
    @Published var shareLocation: Bool = false
    @Published var personalizedAds: Bool = true
    @Published var accountVisibility: AccountVisibility = .private
    @Published var dataRetention: DataRetentionPeriod = .sixMonths
    
    @Published var showingVisibilityPicker: Bool = false
    @Published var showingRetentionPicker: Bool = false
    @Published var showExportSuccess: Bool = false
    @Published var showClearSuccess: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Public Methods
    
    /// Load privacy settings from UserDefaults
    func loadSettings() {
        shareUsageData = UserDefaults.standard.bool(forKey: "shareUsageData")
        shareReadingHistory = UserDefaults.standard.bool(forKey: "shareReadingHistory")
        shareLocation = UserDefaults.standard.bool(forKey: "shareLocation")
        personalizedAds = UserDefaults.standard.bool(forKey: "personalizedAds")
        
        if let visibilityRaw = UserDefaults.standard.string(forKey: "accountVisibility"),
           let visibility = AccountVisibility(rawValue: visibilityRaw) {
            accountVisibility = visibility
        }
        
        if let retentionRaw = UserDefaults.standard.string(forKey: "dataRetention"),
           let retention = DataRetentionPeriod(rawValue: retentionRaw) {
            dataRetention = retention
        }
    }
    
    /// Save privacy settings to UserDefaults
    func saveSettings() {
        UserDefaults.standard.set(shareUsageData, forKey: "shareUsageData")
        UserDefaults.standard.set(shareReadingHistory, forKey: "shareReadingHistory")
        UserDefaults.standard.set(shareLocation, forKey: "shareLocation")
        UserDefaults.standard.set(personalizedAds, forKey: "personalizedAds")
        UserDefaults.standard.set(accountVisibility.rawValue, forKey: "accountVisibility")
        UserDefaults.standard.set(dataRetention.rawValue, forKey: "dataRetention")
    }
    
    /// Export user data
    func exportData() {
        isLoading = true
        
        // TODO: Implement actual data export
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoading = false
            self.showExportSuccess = true
        }
    }
    
    /// Clear all user data
    func clearData() {
        isLoading = true
        
        // TODO: Implement actual data clearing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.showClearSuccess = true
        }
    }
    
    /// Open privacy policy
    func openPrivacyPolicy() {
        // TODO: Open privacy policy URL
        if let url = URL(string: "https://newslocal.com/privacy") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Enums

enum AccountVisibility: String, CaseIterable {
    case `public` = "public"
    case `private` = "private"
    case friends = "friends"
    
    var displayName: String {
        switch self {
        case .public:
            return "Public"
        case .private:
            return "Private"
        case .friends:
            return "Friends Only"
        }
    }
}

enum DataRetentionPeriod: String, CaseIterable {
    case oneMonth = "oneMonth"
    case threeMonths = "threeMonths"
    case sixMonths = "sixMonths"
    case oneYear = "oneYear"
    case forever = "forever"
    
    var displayName: String {
        switch self {
        case .oneMonth:
            return "1 Month"
        case .threeMonths:
            return "3 Months"
        case .sixMonths:
            return "6 Months"
        case .oneYear:
            return "1 Year"
        case .forever:
            return "Forever"
        }
    }
}

// MARK: - Extensions

extension PrivacySettingsViewModel {
    /// Mock data for previews
    static let mock = PrivacySettingsViewModel()
}
