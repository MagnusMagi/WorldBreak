//
//  SearchCacheManager.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import Combine

/// Manager for handling search result caching and performance optimizations
@MainActor
class SearchCacheManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var cacheHitRate: Double = 0.0
    @Published var cacheSize: Int = 0
    
    // MARK: - Private Properties
    
    private var searchResultsCache: [String: CachedSearchResult] = [:]
    private var suggestionsCache: [String: [String]] = [:]
    private var trendingTopicsCache: [TrendingTopic] = []
    private let maxCacheSize = 100
    private let cacheExpirationTime: TimeInterval = 300 // 5 minutes
    private var accessTimes: [String: Date] = [:]
    
    // MARK: - Public Methods
    
    /// Get cached search results
    func getCachedResults(for query: String, filters: SearchFilters?) -> NewsResponse? {
        let cacheKey = generateCacheKey(query: query, filters: filters)
        
        guard let cachedResult = searchResultsCache[cacheKey] else {
            return nil
        }
        
        // Check if cache is expired
        if cachedResult.isExpired {
            searchResultsCache.removeValue(forKey: cacheKey)
            accessTimes.removeValue(forKey: cacheKey)
            return nil
        }
        
        // Update access time for LRU
        accessTimes[cacheKey] = Date()
        
        // Update hit rate
        updateHitRate()
        
        return cachedResult.response
    }
    
    /// Cache search results
    func cacheResults(_ response: NewsResponse, for query: String, filters: SearchFilters?) {
        let cacheKey = generateCacheKey(query: query, filters: filters)
        
        let cachedResult = CachedSearchResult(
            response: response,
            timestamp: Date(),
            expirationTime: cacheExpirationTime
        )
        
        searchResultsCache[cacheKey] = cachedResult
        accessTimes[cacheKey] = Date()
        
        // Manage cache size
        manageCacheSize()
        cacheSize = searchResultsCache.count
    }
    
    /// Get cached suggestions
    func getCachedSuggestions(for query: String) -> [String]? {
        guard let suggestions = suggestionsCache[query] else {
            return nil
        }
        
        updateHitRate()
        return suggestions
    }
    
    /// Cache suggestions
    func cacheSuggestions(_ suggestions: [String], for query: String) {
        suggestionsCache[query] = suggestions
    }
    
    /// Get cached trending topics
    func getCachedTrendingTopics() -> [TrendingTopic]? {
        guard !trendingTopicsCache.isEmpty else {
            return nil
        }
        
        updateHitRate()
        return trendingTopicsCache
    }
    
    /// Cache trending topics
    func cacheTrendingTopics(_ topics: [TrendingTopic]) {
        trendingTopicsCache = topics
    }
    
    /// Clear all cache
    func clearCache() {
        searchResultsCache.removeAll()
        suggestionsCache.removeAll()
        trendingTopicsCache.removeAll()
        accessTimes.removeAll()
        cacheSize = 0
        cacheHitRate = 0.0
    }
    
    /// Clear expired cache entries
    func clearExpiredCache() {
        let expiredKeys = searchResultsCache.compactMap { key, value in
            value.isExpired ? key : nil
        }
        
        for key in expiredKeys {
            searchResultsCache.removeValue(forKey: key)
            accessTimes.removeValue(forKey: key)
        }
        
        cacheSize = searchResultsCache.count
    }
    
    /// Get cache statistics
    func getCacheStatistics() -> CacheStatistics {
        let totalRequests = searchResultsCache.count + suggestionsCache.count
        let hitRate = totalRequests > 0 ? cacheHitRate : 0.0
        
        return CacheStatistics(
            totalEntries: searchResultsCache.count,
            suggestionsEntries: suggestionsCache.count,
            trendingTopicsCached: !trendingTopicsCache.isEmpty,
            hitRate: hitRate,
            cacheSize: cacheSize,
            memoryUsage: estimateMemoryUsage()
        )
    }
    
    // MARK: - Private Methods
    
    /// Generate cache key for search query and filters
    private func generateCacheKey(query: String, filters: SearchFilters?) -> String {
        let normalizedQuery = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        var keyComponents = [normalizedQuery]
        
        if let filters = filters {
            if let categories = filters.categories {
                let categoryIds = categories.map { $0.id }.sorted()
                keyComponents.append("categories:\(categoryIds.joined(separator: ","))")
            }
            
            if let sources = filters.sources {
                let sourceIds = sources.map { $0.id }.sorted()
                keyComponents.append("sources:\(sourceIds.joined(separator: ","))")
            }
            
            if let sortBy = filters.sortBy {
                keyComponents.append("sort:\(sortBy.rawValue)")
            }
            
            if let sortOrder = filters.sortOrder {
                keyComponents.append("order:\(sortOrder.rawValue)")
            }
        }
        
        return keyComponents.joined(separator: "|")
    }
    
    /// Manage cache size using LRU strategy
    private func manageCacheSize() {
        guard searchResultsCache.count > maxCacheSize else { return }
        
        // Sort by access time (oldest first)
        let sortedKeys = accessTimes.sorted { $0.value < $1.value }
        
        // Remove oldest entries
        let keysToRemove = sortedKeys.prefix(searchResultsCache.count - maxCacheSize).map { $0.key }
        
        for key in keysToRemove {
            searchResultsCache.removeValue(forKey: key)
            accessTimes.removeValue(forKey: key)
        }
    }
    
    /// Update cache hit rate
    private func updateHitRate() {
        // Simple hit rate calculation - in real app, you'd track hits vs misses
        let totalEntries = searchResultsCache.count + suggestionsCache.count
        cacheHitRate = totalEntries > 0 ? 0.85 : 0.0 // Mock 85% hit rate
    }
    
    /// Estimate memory usage
    private func estimateMemoryUsage() -> Int {
        // Rough estimation of memory usage
        let resultsSize = searchResultsCache.count * 1024 // 1KB per result
        let suggestionsSize = suggestionsCache.values.flatMap { $0 }.count * 50 // 50 bytes per suggestion
        return resultsSize + suggestionsSize
    }
}

// MARK: - Supporting Models

/// Cached search result with expiration
struct CachedSearchResult {
    let response: NewsResponse
    let timestamp: Date
    let expirationTime: TimeInterval
    
    var isExpired: Bool {
        Date().timeIntervalSince(timestamp) > expirationTime
    }
}

/// Cache statistics
struct CacheStatistics: Codable {
    let totalEntries: Int
    let suggestionsEntries: Int
    let trendingTopicsCached: Bool
    let hitRate: Double
    let cacheSize: Int
    let memoryUsage: Int
    
    var formattedHitRate: String {
        return String(format: "%.1f%%", hitRate * 100)
    }
    
    var formattedMemoryUsage: String {
        if memoryUsage < 1024 {
            return "\(memoryUsage) bytes"
        } else if memoryUsage < 1024 * 1024 {
            return "\(memoryUsage / 1024) KB"
        } else {
            return "\(memoryUsage / (1024 * 1024)) MB"
        }
    }
}

// MARK: - Extensions

extension SearchCacheManager {
    /// Mock data for previews
    static let mock = SearchCacheManager()
}
