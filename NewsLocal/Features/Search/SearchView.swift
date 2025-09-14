import SwiftUI

/// Simplified SearchView with basic search functionality
struct SearchView: View {
    @Binding var selectedTab: TabItem
    @StateObject private var viewModel = SearchViewModel()
    
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
                // Simple Search Bar Section
                VStack(spacing: DesignSystem.Spacing.sm) {
                    SimpleSearchBarView(
                        searchText: $viewModel.searchText,
                        onClear: {
                            viewModel.clearSearch()
                        }
                    )
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.sm)
                
                // Content Section
                if viewModel.hasSearched {
                    SimpleSearchResultsView(viewModel: viewModel)
                } else {
                    SimpleSearchHomeView(viewModel: viewModel)
                }
            }
        }
        .onAppear {
            // Load trending topics when view appears
            viewModel.loadTrendingTopics()
        }
        .alert("Search Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Search screen")
        .accessibilityHint("Search for news articles")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(selectedTab: .constant(.search))
    }
}
