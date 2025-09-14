//
//  SearchResultsView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Results view for Search tab when search has been performed
struct SearchResultsView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Results Header
            SearchResultsHeader(viewModel: viewModel)
            
            // Results Content
            if viewModel.isLoading && viewModel.searchResults.isEmpty {
                LoadingView()
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    viewModel.performSearch()
                }
            } else if viewModel.searchResults.isEmpty {
                EmptyResultsView(query: viewModel.searchText)
            } else {
                SearchResultsList(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Supporting Views

struct SearchResultsHeader: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(viewModel.formattedResultCount)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                if viewModel.hasActiveFilters {
                    Text("with \(viewModel.activeFilterCount) filter\(viewModel.activeFilterCount == 1 ? "" : "s")")
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                }
            }
            
            Spacer()
            
            HStack(spacing: DesignSystem.Spacing.sm) {
                // Filter Button
                Button(action: {
                    viewModel.showingFilters = true
                }) {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Image(systemName: "line.3.horizontal.decrease")
                            .font(.caption)
                        Text("Filter")
                            .font(DesignSystem.Typography.caption1)
                    }
                    .foregroundColor(viewModel.hasActiveFilters ? DesignSystem.Colors.primary : DesignSystem.Colors.textSecondary)
                    .padding(.horizontal, DesignSystem.Spacing.sm)
                    .padding(.vertical, DesignSystem.Spacing.xs)
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                            .fill(viewModel.hasActiveFilters ? DesignSystem.Colors.primary.opacity(0.1) : DesignSystem.Colors.backgroundSecondary)
                    )
                }
                
                // Sort Button
                Button(action: {
                    // TODO: Show sort options
                }) {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.caption)
                        Text("Sort")
                            .font(DesignSystem.Typography.caption1)
                    }
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .padding(.horizontal, DesignSystem.Spacing.sm)
                    .padding(.vertical, DesignSystem.Spacing.xs)
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                            .fill(DesignSystem.Colors.backgroundSecondary)
                    )
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
        .padding(.vertical, DesignSystem.Spacing.sm)
        .background(DesignSystem.Colors.background)
    }
}

struct SearchResultsList: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: DesignSystem.Spacing.md) {
                ForEach(viewModel.searchResults) { article in
                    NewsCardView(article: article)
                        .onAppear {
                            // Load more when reaching near the end
                            if article == viewModel.searchResults.last {
                                viewModel.loadMoreResults()
                            }
                        }
                }
                
                // Loading indicator for pagination
                if viewModel.isLoading && !viewModel.searchResults.isEmpty {
                    HStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(0.8)
                        Spacer()
                    }
                    .padding(.vertical, DesignSystem.Spacing.md)
                }
                
                // Load more button
                if viewModel.hasMoreResults && !viewModel.isLoading {
                    Button("Load More") {
                        viewModel.loadMoreResults()
                    }
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .padding(.vertical, DesignSystem.Spacing.md)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.sm)
        }
    }
}

struct EmptyResultsView: View {
    let query: String
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(DesignSystem.Colors.textTertiary)
            
            VStack(spacing: DesignSystem.Spacing.sm) {
                Text("No results found")
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text("Try searching for something else or check your spelling")
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: DesignSystem.Spacing.sm) {
                Text("Suggestions:")
                    .font(DesignSystem.Typography.callout)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text("• Try different keywords")
                    .font(DesignSystem.Typography.caption1)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                Text("• Check your spelling")
                    .font(DesignSystem.Typography.caption1)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                Text("• Try more general terms")
                    .font(DesignSystem.Typography.caption1)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
        }
        .padding(DesignSystem.Spacing.xl)
    }
}

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(DesignSystem.Colors.error)
            
            VStack(spacing: DesignSystem.Spacing.sm) {
                Text("Search Error")
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text(message)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Try Again") {
                onRetry()
            }
            .primaryButtonStyle()
        }
        .padding(DesignSystem.Spacing.xl)
    }
}

// MARK: - Preview

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(viewModel: SearchViewModel.mock)
    }
}
