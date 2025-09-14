//
//  ThemeSettingsViewModel.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import SwiftUI

/// ViewModel for theme and display settings
@MainActor
class ThemeSettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var selectedTheme: AppTheme = .system
    @Published var dynamicType: Bool = true
    @Published var fontSize: Double = 1.0
    @Published var reduceMotion: Bool = false
    @Published var boldText: Bool = false
    @Published var highContrast: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccessMessage: Bool = false
    
    // MARK: - Computed Properties
    
    var fontSizeDescription: String {
        switch fontSize {
        case 0:
            return "Small - Easier to read more content"
        case 1:
            return "Medium - Balanced reading experience"
        case 2:
            return "Large - Easier to read for accessibility"
        default:
            return "Medium - Balanced reading experience"
        }
    }
    
    // MARK: - Public Methods
    
    /// Load theme settings from UserDefaults
    func loadSettings() {
        if let themeRaw = UserDefaults.standard.string(forKey: "selectedTheme"),
           let theme = AppTheme(rawValue: themeRaw) {
            selectedTheme = theme
        }
        
        dynamicType = UserDefaults.standard.bool(forKey: "dynamicType")
        fontSize = UserDefaults.standard.double(forKey: "fontSize")
        reduceMotion = UserDefaults.standard.bool(forKey: "reduceMotion")
        boldText = UserDefaults.standard.bool(forKey: "boldText")
        highContrast = UserDefaults.standard.bool(forKey: "highContrast")
    }
    
    /// Save theme settings to UserDefaults
    func saveSettings() {
        UserDefaults.standard.set(selectedTheme.rawValue, forKey: "selectedTheme")
        UserDefaults.standard.set(dynamicType, forKey: "dynamicType")
        UserDefaults.standard.set(fontSize, forKey: "fontSize")
        UserDefaults.standard.set(reduceMotion, forKey: "reduceMotion")
        UserDefaults.standard.set(boldText, forKey: "boldText")
        UserDefaults.standard.set(highContrast, forKey: "highContrast")
        
        // Apply theme changes
        applyTheme()
        
        showSuccessMessage = true
    }
    
    /// Apply theme settings to the app
    private func applyTheme() {
        // TODO: Apply theme changes to the app
        // This would typically involve updating the app's appearance
        print("🎨 Theme applied: \(selectedTheme.rawValue)")
    }
}

// MARK: - Enums

enum AppTheme: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    
    var displayName: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        case .system:
            return "System"
        }
    }
}

// MARK: - Extensions

extension ThemeSettingsViewModel {
    /// Mock data for previews
    static let mock = ThemeSettingsViewModel()
}
