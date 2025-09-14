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
    private let maxHistoryItems = 10
    
    // MARK: - Initialization
    
    init(newsService: NewsServiceProtocol = ServiceFactory.shared.newsService) {
        self.newsService = newsService
        loadSearchHistory()
        loadTrendingTopics()
        setupSearchTextObserver()
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
        addToSearchHistory(searchText)
        
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
                    self?.errorMessage = error.localizedDescription
                }
            },
            receiveValue: { [weak self] response in
                self?.searchResults = response.articles
                self?.totalResults = response.totalResults
                self?.hasMoreResults = response.hasMore
                self?.hasSearched = true
                self?.currentPage = response.page
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
        searchHistory = []
        saveSearchHistory()
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
            searchSuggestions = []
            return
        }
        
        newsService.getSearchSuggestions(query: query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] suggestions in
                    self?.searchSuggestions = suggestions
                }
            )
            .store(in: &cancellables)
    }
    
    /// Load trending topics (public method)
    func loadTrendingTopics() {
        newsService.getTrendingTopics(limit: 10)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] topics in
                    self?.trendingTopics = topics
                }
            )
            .store(in: &cancellables)
    }
    
    /// Load search history from UserDefaults
    private func loadSearchHistory() {
        if let history = UserDefaults.standard.stringArray(forKey: "searchHistory") {
            searchHistory = history
        }
    }
    
    /// Save search history to UserDefaults
    private func saveSearchHistory() {
        UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
    }
    
    /// Add query to search history
    private func addToSearchHistory(_ query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }
        
        // Remove if already exists
        searchHistory.removeAll { $0 == trimmedQuery }
        
        // Add to beginning
        searchHistory.insert(trimmedQuery, at: 0)
        
        // Limit history size
        if searchHistory.count > maxHistoryItems {
            searchHistory = Array(searchHistory.prefix(maxHistoryItems))
        }
        
        saveSearchHistory()
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
