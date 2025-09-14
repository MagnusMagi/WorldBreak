//
//  SimpleSearchHistoryManager.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation

/// Simple search history manager for basic search functionality
class SimpleSearchHistoryManager: ObservableObject {
    @Published var searchHistory: [String] = []
    
    private let maxHistoryCount = 10
    private let userDefaults = UserDefaults.standard
    private let historyKey = "SimpleSearchHistory"
    
    init() {
        loadHistory()
    }
    
    /// Add a search query to history
    func addSearchQuery(_ query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }
        
        // Remove if already exists
        searchHistory.removeAll { $0.lowercased() == trimmedQuery.lowercased() }
        
        // Add to beginning
        searchHistory.insert(trimmedQuery, at: 0)
        
        // Limit history size
        if searchHistory.count > maxHistoryCount {
            searchHistory = Array(searchHistory.prefix(maxHistoryCount))
        }
        
        saveHistory()
    }
    
    /// Get recent searches
    func getRecentSearches() -> [String] {
        return searchHistory
    }
    
    /// Clear all history
    func clearAllHistory() {
        searchHistory.removeAll()
        saveHistory()
    }
    
    /// Load history from UserDefaults
    private func loadHistory() {
        if let history = userDefaults.stringArray(forKey: historyKey) {
            searchHistory = history
        }
    }
    
    /// Save history to UserDefaults
    private func saveHistory() {
        userDefaults.set(searchHistory, forKey: historyKey)
    }
}
