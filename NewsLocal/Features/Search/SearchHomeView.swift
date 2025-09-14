//
//  SearchHomeView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Home view for Search tab when no search has been performed
struct SearchHomeView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.lg) {
                // Trending Topics Section
                if !viewModel.trendingTopics.isEmpty {
                    TrendingTopicsSection(viewModel: viewModel)
                }
                
                // Search History Section
                if !viewModel.searchHistory.isEmpty {
                    SearchHistorySection(viewModel: viewModel)
                }
                
                // Category Suggestions Section
                CategorySuggestionsSection(viewModel: viewModel)
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.sm)
        }
    }
}

// MARK: - Supporting Views

struct TrendingTopicsSection: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("Trending Now")
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
                
                Button("See All") {
                    // TODO: Navigate to trending topics page
                }
                .font(DesignSystem.Typography.caption1)
                .foregroundColor(DesignSystem.Colors.primary)
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: DesignSystem.Spacing.md) {
                ForEach(viewModel.trendingTopics.prefix(6)) { topic in
                    TrendingTopicCard(topic: topic) {
                        viewModel.searchTrendingTopic(topic)
                    }
                }
            }
        }
    }
}

struct SearchHistorySection: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("Recent Searches")
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
                
                Button("Clear") {
                    viewModel.clearSearchHistory()
                }
                .font(DesignSystem.Typography.caption1)
                .foregroundColor(DesignSystem.Colors.error)
            }
            
            VStack(spacing: DesignSystem.Spacing.sm) {
                ForEach(viewModel.searchHistory.prefix(5), id: \.self) { query in
                    SearchHistoryItem(query: query) {
                        viewModel.searchFromHistory(query)
                    }
                }
            }
        }
    }
}

struct CategorySuggestionsSection: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Browse by Category")
                .font(DesignSystem.Typography.title3)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: DesignSystem.Spacing.md) {
                ForEach(NewsCategory.allCases.prefix(9)) { category in
                    CategorySuggestionChip(category: category) {
                        viewModel.searchText = category.displayName
                        viewModel.performSearch()
                    }
                }
            }
        }
    }
}

// MARK: - Card Components

struct TrendingTopicCard: View {
    let topic: TrendingTopic
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                HStack {
                    Text(topic.topic)
                        .font(DesignSystem.Typography.callout)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundColor(DesignSystem.Colors.primary)
                }
                
                HStack {
                    if let category = topic.category {
                        Text(category.displayName)
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text("\(topic.articleCount) articles")
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.backgroundSecondary)
            .cornerRadius(DesignSystem.CornerRadius.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SearchHistoryItem: View {
    let query: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.md) {
                Image(systemName: "clock")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .frame(width: 16)
                
                Text(query)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
                
                Image(systemName: "arrow.up.left")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.sm)
            .background(DesignSystem.Colors.backgroundSecondary)
            .cornerRadius(DesignSystem.CornerRadius.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategorySuggestionChip: View {
    let category: NewsCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: DesignSystem.Spacing.xs) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(DesignSystem.Colors.primary)
                
                Text(category.displayName)
                    .font(DesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.backgroundSecondary)
            .cornerRadius(DesignSystem.CornerRadius.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

struct SearchHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHomeView(viewModel: SearchViewModel.mock)
    }
}
