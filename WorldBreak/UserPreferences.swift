//
//  UserPreferences.swift
//  WorldBreak
//
//  Created by Magnus Magi on 16.09.2025.
//

import SwiftUI
import Foundation
import Combine

class UserPreferences: ObservableObject {
    @Published var selectedCategories: [Category] = []
    @Published var selectedTheme: Theme = Theme.allThemes[0]
    @Published var isOnboardingCompleted: Bool = false
    @Published var isPersonalizationCompleted: Bool = false
    
    var hasMinimumCategories: Bool {
        selectedCategories.count >= 3
    }
    
    func toggleCategory(_ category: Category) {
        if let index = selectedCategories.firstIndex(of: category) {
            selectedCategories.remove(at: index)
        } else {
            selectedCategories.append(category)
        }
    }
    
    func selectTheme(_ theme: Theme) {
        selectedTheme = theme
    }
    
    func completePersonalization() {
        isPersonalizationCompleted = true
    }
}
