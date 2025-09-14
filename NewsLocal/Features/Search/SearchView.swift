import SwiftUI

/// Main SearchView with SearchBar integration and content switching
struct SearchView: View {
    @Binding var selectedTab: TabItem
    @StateObject private var viewModel = SearchViewModel()
    @State private var showingFilterSheet = false
    @State private var showingVoiceSearch = false
    @State private var showingImageSearch = false
    
    var body: some View {
        StandardPageWrapper(
            title: "Search",
            showCategories: false,
            selectedCategory: nil,
            selectedTab: selectedTab,
            onCategorySelected: nil,
            onTabSelected: { tab in
                selectedTab = tab
            }
        ) {
            VStack(spacing: 0) {
                // Search Bar Section
                VStack(spacing: DesignSystem.Spacing.sm) {
                    SearchBarView(
                        searchText: $viewModel.searchText,
                        onSearchButtonClicked: {
                            viewModel.performSearch()
                        },
                        onSuggestionSelected: { suggestion in
                            viewModel.searchText = suggestion
                            viewModel.performSearch()
                        },
                        onVoiceSearch: {
                            showingVoiceSearch = true
                        },
                        onImageSearch: {
                            showingImageSearch = true
                        },
                        onClear: {
                            viewModel.clearSearch()
                        }
                    )
                    
                    // Active Filters Bar (if filters are active)
                    if viewModel.hasActiveFilters {
                        ActiveFiltersBar(
                            filterCount: viewModel.activeFilterCount,
                            onClearFilters: {
                                viewModel.clearFilters()
                            },
                            onShowFilters: {
                                showingFilterSheet = true
                            }
                        )
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.sm)
                
                // Content Section
                if viewModel.hasSearched {
                    SearchResultsView(viewModel: viewModel)
                } else {
                    SearchHomeView(viewModel: viewModel)
                }
            }
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterSheet(
                filters: $viewModel.filters,
                onApply: { filters in
                    viewModel.applyFilters(filters)
                    showingFilterSheet = false
                },
                onClear: {
                    viewModel.clearFilters()
                    showingFilterSheet = false
                }
            )
        }
        .sheet(isPresented: $showingVoiceSearch) {
            VoiceSearchView(
                isPresented: $showingVoiceSearch,
                onSearchResult: { result in
                    viewModel.searchText = result
                    viewModel.performSearch()
                }
            )
        }
        .sheet(isPresented: $showingImageSearch) {
            ImageSearchView(
                isPresented: $showingImageSearch,
                onSearchResult: { result in
                    viewModel.searchText = result
                    viewModel.performSearch()
                }
            )
        }
        .onAppear {
            // Load trending topics and search history when view appears
            viewModel.loadTrendingTopics()
        }
        .alert("Search Error", isPresented: $viewModel.errorHandler.showingErrorAlert) {
            Button("OK") {
                viewModel.errorHandler.clearError()
            }
            
            if let action = viewModel.errorHandler.errorAction {
                Button("Retry") {
                    action()
                    viewModel.errorHandler.clearError()
                }
            }
        } message: {
            Text(viewModel.errorHandler.errorMessage)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Search screen")
        .accessibilityHint("Search for news articles using text, voice, or images")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(selectedTab: .constant(.search))
    }
}
