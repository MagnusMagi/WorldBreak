//
//  SearchHistoryManager.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import Combine

/// Manager for handling search history with local storage and analytics
@MainActor
class SearchHistoryManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var searchHistory: [NewsLocal.SearchHistoryItem] = []
    @Published var favoriteSearches: [String] = []
    @Published var recentSearches: [String] = []
    
    // MARK: - Private Properties
    
    private let maxHistoryItems = 50
    private let maxRecentItems = 10
    private let userDefaults = UserDefaults.standard
    private let searchHistoryKey = "searchHistory"
    private let favoriteSearchesKey = "favoriteSearches"
    private let recentSearchesKey = "recentSearches"
    
    // MARK: - Initialization
    
    init() {
        loadSearchHistory()
        loadFavoriteSearches()
        loadRecentSearches()
    }
    
    // MARK: - Public Methods
    
    /// Add a search query to history
    func addSearchQuery(_ query: String, category: String? = nil) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }
        
        // Create search history item
        let historyItem = SearchHistoryItem(
            query: trimmedQuery,
            category: category,
            timestamp: Date(),
            searchCount: 1
        )
        
        // Remove if already exists
        searchHistory.removeAll { $0.query == trimmedQuery }
        
        // Add to beginning
        searchHistory.insert(historyItem, at: 0)
        
        // Limit history size
        if searchHistory.count > maxHistoryItems {
            searchHistory = Array(searchHistory.prefix(maxHistoryItems))
        }
        
        // Update recent searches
        updateRecentSearches(query: trimmedQuery)
        
        // Save to UserDefaults
        saveSearchHistory()
    }
    
    /// Remove a search query from history
    func removeSearchQuery(_ query: String) {
        searchHistory.removeAll { $0.query == query }
        recentSearches.removeAll { $0 == query }
        favoriteSearches.removeAll { $0 == query }
        
        saveSearchHistory()
        saveRecentSearches()
        saveFavoriteSearches()
    }
    
    /// Clear all search history
    func clearAllHistory() {
        searchHistory = []
        recentSearches = []
        favoriteSearches = []
        
        saveSearchHistory()
        saveRecentSearches()
        saveFavoriteSearches()
    }
    
    /// Toggle favorite status of a search
    func toggleFavorite(_ query: String) {
        if favoriteSearches.contains(query) {
            favoriteSearches.removeAll { $0 == query }
        } else {
            favoriteSearches.append(query)
        }
        
        saveFavoriteSearches()
    }
    
    /// Check if a search is favorited
    func isFavorite(_ query: String) -> Bool {
        return favoriteSearches.contains(query)
    }
    
    /// Get search suggestions based on history
    func getSearchSuggestions(for query: String) -> [String] {
        guard !query.isEmpty else { return recentSearches }
        
        let suggestions = searchHistory
            .filter { $0.query.localizedCaseInsensitiveContains(query) }
            .sorted { $0.searchCount > $1.searchCount }
            .prefix(5)
            .map { $0.query }
        
        return Array(suggestions)
    }
    
    /// Get trending searches from history
    func getTrendingSearches(limit: Int = 10) -> [NewsLocal.SearchHistoryItem] {
        return Array(searchHistory
            .sorted { $0.searchCount > $1.searchCount }
            .prefix(limit))
    }
    
    /// Get recent searches
    func getRecentSearches(limit: Int = 5) -> [String] {
        return Array(recentSearches.prefix(limit))
    }
    
    /// Get favorite searches
    func getFavoriteSearches() -> [String] {
        return favoriteSearches
    }
    
    /// Update search count for analytics
    func updateSearchCount(for query: String) {
        if let index = searchHistory.firstIndex(where: { $0.query == query }) {
            searchHistory[index].searchCount += 1
            saveSearchHistory()
        }
    }
    
    /// Get search analytics
    func getSearchAnalytics() -> SearchAnalytics {
        let totalSearches = searchHistory.reduce(0) { $0 + $1.searchCount }
        let uniqueSearches = searchHistory.count
        let favoriteCount = favoriteSearches.count
        
        return SearchAnalytics(
            totalSearches: totalSearches,
            uniqueSearches: uniqueSearches,
            favoriteCount: favoriteCount,
            mostSearched: getTrendingSearches(limit: 1).first?.query ?? ""
        )
    }
    
    // MARK: - Private Methods
    
    /// Update recent searches list
    private func updateRecentSearches(query: String) {
        recentSearches.removeAll { $0 == query }
        recentSearches.insert(query, at: 0)
        
        if recentSearches.count > maxRecentItems {
            recentSearches = Array(recentSearches.prefix(maxRecentItems))
        }
        
        saveRecentSearches()
    }
    
    /// Load search history from UserDefaults
    private func loadSearchHistory() {
        if let data = userDefaults.data(forKey: searchHistoryKey),
           let history = try? JSONDecoder().decode([NewsLocal.SearchHistoryItem].self, from: data) {
            searchHistory = history
        }
    }
    
    /// Save search history to UserDefaults
    private func saveSearchHistory() {
        if let data = try? JSONEncoder().encode(searchHistory) {
            userDefaults.set(data, forKey: searchHistoryKey)
        }
    }
    
    /// Load favorite searches from UserDefaults
    private func loadFavoriteSearches() {
        if let favorites = userDefaults.stringArray(forKey: favoriteSearchesKey) {
            favoriteSearches = favorites
        }
    }
    
    /// Save favorite searches to UserDefaults
    private func saveFavoriteSearches() {
        userDefaults.set(favoriteSearches, forKey: favoriteSearchesKey)
    }
    
    /// Load recent searches from UserDefaults
    private func loadRecentSearches() {
        if let recent = userDefaults.stringArray(forKey: recentSearchesKey) {
            recentSearches = recent
        }
    }
    
    /// Save recent searches to UserDefaults
    private func saveRecentSearches() {
        userDefaults.set(recentSearches, forKey: recentSearchesKey)
    }
}

// MARK: - Supporting Models

/// Represents a search history item
struct SearchHistoryItem: Identifiable, Codable, Equatable {
    let id = UUID()
    let query: String
    let category: String?
    let timestamp: Date
    var searchCount: Int
    
    init(query: String, category: String?, timestamp: Date, searchCount: Int) {
        self.query = query
        self.category = category
        self.timestamp = timestamp
        self.searchCount = searchCount
    }
    
    enum CodingKeys: String, CodingKey {
        case query, category, timestamp, searchCount
    }
}

/// Search analytics data
struct SearchAnalytics: Codable {
    let totalSearches: Int
    let uniqueSearches: Int
    let favoriteCount: Int
    let mostSearched: String
    
    var averageSearchesPerQuery: Double {
        return uniqueSearches > 0 ? Double(totalSearches) / Double(uniqueSearches) : 0
    }
}

// MARK: - Extensions

extension SearchHistoryManager {
    /// Mock data for previews
    static let mock = SearchHistoryManager()
}
