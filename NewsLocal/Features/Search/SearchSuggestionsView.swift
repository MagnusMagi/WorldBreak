//
//  SearchSuggestionsView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// View for displaying search suggestions and popular searches
struct SearchSuggestionsView: View {
    @ObservedObject var viewModel: SearchViewModel
    let onSuggestionSelected: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Search Suggestions (if user is typing)
            if !viewModel.searchText.isEmpty && !viewModel.searchSuggestions.isEmpty {
                SearchSuggestionsSection(
                    suggestions: viewModel.searchSuggestions,
                    onSuggestionSelected: onSuggestionSelected
                )
            }
            
            // Popular Searches (if search is empty)
            if viewModel.searchText.isEmpty {
                PopularSearchesSection(
                    onSuggestionSelected: onSuggestionSelected
                )
            }
        }
    }
}

// MARK: - Search Suggestions Section

struct SearchSuggestionsSection: View {
    let suggestions: [String]
    let onSuggestionSelected: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Suggestions")
                    .font(DesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .textCase(.uppercase)
                
                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.top, DesignSystem.Spacing.sm)
            
            ForEach(suggestions.prefix(5), id: \.self) { suggestion in
                SearchSuggestionRow(
                    suggestion: suggestion,
                    onSelected: {
                        onSuggestionSelected(suggestion)
                    }
                )
            }
        }
        .background(DesignSystem.Colors.background)
    }
}

// MARK: - Popular Searches Section

struct PopularSearchesSection: View {
    let onSuggestionSelected: (String) -> Void
    
    private let popularSearches = [
        "Technology News",
        "Climate Change",
        "Stock Market",
        "Sports Updates",
        "Health & Wellness",
        "Entertainment",
        "Politics",
        "Science Discovery",
        "Business News",
        "World Events"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Popular Searches")
                    .font(DesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .textCase(.uppercase)
                
                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.top, DesignSystem.Spacing.sm)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: DesignSystem.Spacing.xs) {
                ForEach(popularSearches.prefix(8), id: \.self) { search in
                    PopularSearchChip(
                        search: search,
                        onSelected: {
                            onSuggestionSelected(search)
                        }
                    )
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.sm)
        }
        .background(DesignSystem.Colors.background)
    }
}

// MARK: - Search Suggestion Row

struct SearchSuggestionRow: View {
    let suggestion: String
    let onSelected: () -> Void
    
    var body: some View {
        Button(action: onSelected) {
            HStack(spacing: DesignSystem.Spacing.md) {
                Image(systemName: "magnifyingglass")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
                    .frame(width: 16)
                
                Text(suggestion)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: "arrow.up.left")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.sm)
        }
        .buttonStyle(PlainButtonStyle())
        
        // Divider (except for last item)
        if suggestion != suggestion {
            Divider()
                .padding(.leading, DesignSystem.Spacing.xl + DesignSystem.Spacing.md)
        }
    }
}

// MARK: - Popular Search Chip

struct PopularSearchChip: View {
    let search: String
    let onSelected: () -> Void
    
    var body: some View {
        Button(action: onSelected) {
            HStack(spacing: DesignSystem.Spacing.xs) {
                Image(systemName: "flame.fill")
                    .font(.caption2)
                    .foregroundColor(DesignSystem.Colors.warning)
                
                Text(search)
                    .font(DesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .lineLimit(1)
            }
            .padding(.horizontal, DesignSystem.Spacing.sm)
            .padding(.vertical, DesignSystem.Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.full)
                    .fill(DesignSystem.Colors.backgroundSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.full)
                            .stroke(DesignSystem.Colors.border, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Search Suggestions Dropdown

struct SearchSuggestionsDropdown: View {
    let searchText: String
    let onSuggestionSelected: (String) -> Void
    
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Search Suggestions (if user is typing)
            if !searchText.isEmpty && !viewModel.searchSuggestions.isEmpty {
                SearchSuggestionsSection(
                    suggestions: viewModel.searchSuggestions,
                    onSuggestionSelected: onSuggestionSelected
                )
            }
            
            // Popular Searches (if search is empty)
            if searchText.isEmpty {
                PopularSearchesSection(
                    onSuggestionSelected: onSuggestionSelected
                )
            }
        }
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                .fill(DesignSystem.Colors.background)
                .shadow(
                    color: DesignSystem.Colors.shadow.opacity(0.1),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                .stroke(DesignSystem.Colors.border, lineWidth: 1)
        )
        .onAppear {
            viewModel.searchText = searchText
            if !searchText.isEmpty {
                viewModel.loadSearchSuggestions(for: searchText)
            }
        }
        .onChange(of: searchText) { newValue in
            viewModel.searchText = newValue
            if !newValue.isEmpty {
                viewModel.loadSearchSuggestions(for: newValue)
            }
        }
    }
}

// MARK: - Preview

struct SearchSuggestionsView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchSuggestionsView(
                viewModel: SearchViewModel.mock,
                onSuggestionSelected: { _ in }
            )
        }
        .previewLayout(.sizeThatFits)
    }
}
