//
//  AppColors.swift
//  WorldBreak
//
//  Created by Magnus Magi on 16.09.2025.
//

import SwiftUI

struct AppColors {
    // Primary Colors
    static let primary = Color.blue
    static let secondary = Color.gray
    
    // Background Colors
    static let background = Color(.systemBackground)
    static let cardBackground = Color(.secondarySystemBackground)
    static let groupedBackground = Color(.systemGroupedBackground)
    
    // Text Colors
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    static let tertiaryText = Color(.tertiaryLabel)
    
    // Accent Colors
    static let accent = Color.blue
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    // Category Colors
    static let technology = Color.blue
    static let sports = Color.green
    static let economy = Color.orange
    static let health = Color.red
    static let education = Color.purple
    static let art = Color.pink
    static let politics = Color.gray
    static let world = Color.cyan
    static let science = Color.indigo
    static let environment = Color.mint
    static let travel = Color.teal
    static let food = Color.brown
    static let fashion = Color.purple
    static let music = Color.pink
    static let cinema = Color.red
    static let gaming = Color.orange
    
    // Theme Colors
    static let lightTheme = Color(.systemBackground)
    static let darkTheme = Color(.systemBackground)
}

// MARK: - Color Extensions
extension Color {
    static let appPrimary = AppColors.primary
    static let appSecondary = AppColors.secondary
    static let appBackground = AppColors.background
    static let appCardBackground = AppColors.cardBackground
    static let appAccent = AppColors.accent
}
