//
//  SimpleSearchResultsView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Simple search results view with basic article listing
struct SimpleSearchResultsView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Results header
            HStack {
                Text(viewModel.formattedResultCount)
                    .font(DesignSystem.Typography.caption1)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.bottom, DesignSystem.Spacing.sm)
            
            // Results list
            if viewModel.isLoading && viewModel.searchResults.isEmpty {
                // Loading state
                VStack(spacing: DesignSystem.Spacing.md) {
                    ProgressView()
                        .scaleEffect(1.2)
                    Text("Searching...")
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.searchResults.isEmpty {
                // No results state
                VStack(spacing: DesignSystem.Spacing.md) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    
                    Text("No results found")
                        .font(DesignSystem.Typography.title3)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    
                    Text("Try different keywords")
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Results list
                ScrollView {
                    LazyVStack(spacing: DesignSystem.Spacing.md) {
                        ForEach(viewModel.searchResults) { article in
                            SimpleNewsCard(article: article)
                        }
                        
                        // Load more button
                        if viewModel.hasMoreResults {
                            Button(action: {
                                viewModel.loadMoreResults()
                            }) {
                                HStack {
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                    } else {
                                        Image(systemName: "arrow.down")
                                    }
                                    Text(viewModel.isLoading ? "Loading..." : "Load More")
                                        .font(DesignSystem.Typography.callout)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(DesignSystem.Colors.primary)
                                .padding(.vertical, DesignSystem.Spacing.md)
                                .frame(maxWidth: .infinity)
                                .background(DesignSystem.Colors.backgroundSecondary)
                                .cornerRadius(DesignSystem.CornerRadius.md)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(viewModel.isLoading)
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.md)
                }
            }
        }
    }
}

// MARK: - News Card Component

struct SimpleNewsCard: View {
    let article: NewsArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            // Title
            Text(article.title)
                .font(DesignSystem.Typography.title3)
                .fontWeight(.medium)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .lineLimit(3)
            
            // Summary
            if !article.summary.isEmpty {
                Text(article.summary)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .lineLimit(3)
            }
            
            // Meta information
            HStack {
                Text(article.source.name)
                    .font(DesignSystem.Typography.caption1)
                    .foregroundColor(DesignSystem.Colors.primary)
                
                Spacer()
                
                Text(article.publishedAt.formatted(.relative(presentation: .named)))
                    .font(DesignSystem.Typography.caption1)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.backgroundSecondary)
        .cornerRadius(DesignSystem.CornerRadius.md)
        .onTapGesture {
            // TODO: Navigate to article detail
        }
    }
}

// MARK: - Preview

struct SimpleSearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleSearchResultsView(viewModel: SearchViewModel())
    }
}
