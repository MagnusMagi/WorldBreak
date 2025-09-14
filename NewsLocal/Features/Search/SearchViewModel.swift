//
//  SearchViewModel.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel for SearchView managing search functionality and state
@MainActor
class SearchViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var searchText: String = ""
    @Published var searchResults: [NewsArticle] = []
    @Published var trendingTopics: [TrendingTopic] = []
    @Published var searchSuggestions: [String] = []
    @Published var searchHistory: [String] = []
    @Published var isLoading: Bool = false
    @Published var hasSearched: Bool = false
    @Published var errorMessage: String?
    @Published var filters: SearchFilters = SearchFilters()
    @Published var showingFilters: Bool = false
    @Published var currentPage: Int = 1
    @Published var hasMoreResults: Bool = true
    @Published var totalResults: Int = 0
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let newsService: NewsServiceProtocol
    private var searchWorkItem: DispatchWorkItem?
    let searchHistoryManager = SearchHistoryManager()
    let cacheManager = SearchCacheManager()
    let errorHandler = SearchErrorHandler()
    let accessibilityManager = SearchAccessibilityManager()
    
    // MARK: - Initialization
    
    init(newsService: NewsServiceProtocol = ServiceFactory.shared.newsService) {
        self.newsService = newsService
        loadSearchHistory()
        loadTrendingTopics()
        setupSearchTextObserver()
        setupHistoryManagerObserver()
    }
    
    // MARK: - Public Methods
    
    /// Perform search with current query and filters
    func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        // Cancel previous search
        searchWorkItem?.cancel()
        
        // Create new search work item
        let workItem = DispatchWorkItem { [weak self] in
            self?.executeSearch()
        }
        searchWorkItem = workItem
        
        // Execute search after debounce delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }
    
    /// Execute the actual search
    private func executeSearch() {
        isLoading = true
        errorMessage = nil
        currentPage = 1
        hasMoreResults = true
        
        // Add to search history
        searchHistoryManager.addSearchQuery(searchText)
        
        // Check cache first
        if let cachedResponse = cacheManager.getCachedResults(for: searchText, filters: filters.isEmpty ? nil : filters) {
            searchResults = cachedResponse.articles
            totalResults = cachedResponse.totalResults
            hasMoreResults = cachedResponse.hasMore
            hasSearched = true
            currentPage = cachedResponse.page
            isLoading = false
            return
        }
        
        // Perform search
        newsService.searchArticles(
            query: searchText,
            filters: filters.isEmpty ? nil : filters,
            page: currentPage,
            limit: 20
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorHandler.handleError(error, context: .search)
                    self?.errorMessage = error.localizedDescription
                }
            },
            receiveValue: { [weak self] response in
                self?.searchResults = response.articles
                self?.totalResults = response.totalResults
                self?.hasMoreResults = response.hasMore
                self?.hasSearched = true
                self?.currentPage = response.page
                
                // Cache the results
                self?.cacheManager.cacheResults(response, for: self?.searchText ?? "", filters: self?.filters.isEmpty == false ? self?.filters : nil)
            }
        )
        .store(in: &cancellables)
    }
    
    /// Load more search results (pagination)
    func loadMoreResults() {
        guard hasMoreResults && !isLoading else { return }
        
        isLoading = true
        currentPage += 1
        
        newsService.searchArticles(
            query: searchText,
            filters: filters.isEmpty ? nil : filters,
            page: currentPage,
            limit: 20
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            },
            receiveValue: { [weak self] response in
                self?.searchResults.append(contentsOf: response.articles)
                self?.hasMoreResults = response.hasMore
                self?.currentPage = response.page
            }
        )
        .store(in: &cancellables)
    }
    
    /// Clear search results and reset state
    func clearSearch() {
        searchText = ""
        searchResults = []
        hasSearched = false
        errorMessage = nil
        currentPage = 1
        hasMoreResults = true
        totalResults = 0
    }
    
    /// Apply filters and refresh search
    func applyFilters(_ newFilters: SearchFilters) {
        filters = newFilters
        if hasSearched {
            performSearch()
        }
    }
    
    /// Clear all filters
    func clearFilters() {
        filters = SearchFilters()
        if hasSearched {
            performSearch()
        }
    }
    
    /// Search for trending topic
    func searchTrendingTopic(_ topic: TrendingTopic) {
        searchText = topic.topic
        performSearch()
    }
    
    /// Search from history
    func searchFromHistory(_ query: String) {
        searchText = query
        performSearch()
    }
    
    /// Clear search history
    func clearSearchHistory() {
        searchHistoryManager.clearAllHistory()
    }
    
    // MARK: - Private Methods
    
    /// Setup search text observer for suggestions
    private func setupSearchTextObserver() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.loadSearchSuggestions(for: query)
            }
            .store(in: &cancellables)
    }
    
    /// Load search suggestions (public method)
    func loadSearchSuggestions(for query: String) {
        guard query.count >= 2 else {
            // Show history-based suggestions for short queries
            searchSuggestions = searchHistoryManager.getSearchSuggestions(for: query)
            return
        }
        
        // Check cache first
        if let cachedSuggestions = cacheManager.getCachedSuggestions(for: query) {
            let historySuggestions = searchHistoryManager.getSearchSuggestions(for: query)
            let combinedSuggestions = Array(Set(cachedSuggestions + historySuggestions))
            searchSuggestions = Array(combinedSuggestions.prefix(5))
            return
        }
        
        // Combine API suggestions with history-based suggestions
        newsService.getSearchSuggestions(query: query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] apiSuggestions in
                    let historySuggestions = self?.searchHistoryManager.getSearchSuggestions(for: query) ?? []
                    let combinedSuggestions = Array(Set(apiSuggestions + historySuggestions))
                    self?.searchSuggestions = Array(combinedSuggestions.prefix(5))
                    
                    // Cache the API suggestions
                    self?.cacheManager.cacheSuggestions(apiSuggestions, for: query)
                }
            )
            .store(in: &cancellables)
    }
    
    /// Load trending topics (public method)
    func loadTrendingTopics() {
        // Check cache first
        if let cachedTopics = cacheManager.getCachedTrendingTopics() {
            trendingTopics = cachedTopics
            return
        }
        
        newsService.getTrendingTopics(limit: 10)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] topics in
                    self?.trendingTopics = topics
                    self?.cacheManager.cacheTrendingTopics(topics)
                }
            )
            .store(in: &cancellables)
    }
    
    /// Setup history manager observer
    private func setupHistoryManagerObserver() {
        searchHistoryManager.$searchHistory
            .map { $0.map { $0.query } }
            .assign(to: \.searchHistory, on: self)
            .store(in: &cancellables)
        
        searchHistoryManager.$recentSearches
            .assign(to: \.searchHistory, on: self)
            .store(in: &cancellables)
    }
    
    /// Load search history from SearchHistoryManager
    private func loadSearchHistory() {
        searchHistory = searchHistoryManager.getRecentSearches()
    }
    
    // MARK: - Computed Properties
    
    /// Check if there are active filters
    var hasActiveFilters: Bool {
        return !filters.isEmpty
    }
    
    /// Get active filter count
    var activeFilterCount: Int {
        return filters.activeFilterCount
    }
    
    /// Check if search is empty
    var isSearchEmpty: Bool {
        return searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Get formatted result count
    var formattedResultCount: String {
        if totalResults == 0 {
            return "No results"
        } else if totalResults == 1 {
            return "1 result"
        } else {
            return "\(totalResults) results"
        }
    }
}

// MARK: - Extensions

extension SearchViewModel {
    /// Mock data for previews
    static let mock = SearchViewModel()
}
