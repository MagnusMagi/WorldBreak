//
//  StandardizedHomepageView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Standardized homepage view that uses the article manager and standards
struct StandardizedHomepageView: View {
    @StateObject private var articleManager = HomepageArticleManager()
    @Binding var selectedTab: TabItem
    
    var body: some View {
        NavigationView {
            StandardPageWrapper(
                title: "Home",
                showCategories: true,
                selectedCategory: nil,
                selectedTab: .home,
                onCategorySelected: { _ in },
                onTabSelected: { tab in
                    selectedTab = tab
                }
            ) {
                ScrollView {
                    LazyVStack(spacing: DesignSystem.Spacing.lg) {
                        // Breaking News Banner
                        if !articleManager.breakingNews.isEmpty {
                            BreakingNewsBanner(
                                articles: articleManager.breakingNews,
                                onTap: { article in
                                    // TODO: Navigate to article detail
                                }
                            )
                        }
                        
                        // Hero Article
                        if let heroArticle = articleManager.heroArticle {
                            HeroArticleCard(article: heroArticle) {
                                // TODO: Navigate to article detail
                            }
                            .padding(.horizontal, DesignSystem.Spacing.md)
                        }
                        
                        // Trending Articles
                        if !articleManager.trendingArticles.isEmpty {
                            TrendingArticlesSection(
                                articles: articleManager.trendingArticles,
                                onArticleTap: { article in
                                    // TODO: Navigate to article detail
                                }
                            )
                        }
                        
                        // Category Sections
                        ForEach(Array(articleManager.categoryArticles.keys.prefix(4)), id: \.id) { category in
                            if let articles = articleManager.categoryArticles[category], !articles.isEmpty {
                                CategoryArticlesSection(
                                    category: category,
                                    articles: articles,
                                    onArticleTap: { article in
                                        // TODO: Navigate to article detail
                                    },
                                    onSeeAll: {
                                        // TODO: Navigate to category view
                                    }
                                )
                            }
                        }
                        
                        // Feed Articles
                        if !articleManager.feedArticles.isEmpty {
                            FeedArticlesSection(
                                articles: articleManager.feedArticles,
                                onArticleTap: { article in
                                    // TODO: Navigate to article detail
                                }
                            )
                        }
                        
                        // Loading State
                        if articleManager.isLoading {
                            LoadingStateView(
                                message: "Loading articles...",
                                actionTitle: nil,
                                action: nil
                            )
                        }
                        
                        // Error State
                        if let error = articleManager.error {
                            ErrorStateView(
                                error: error,
                                onRetry: {
                                    articleManager.loadHomepageArticles()
                                }
                            )
                        }
                    }
                    .padding(.bottom, 100) // Bottom bar space
                }
                .refreshable {
                    await refreshHomepage()
                }
            }
            .onAppear {
                articleManager.loadHomepageArticles()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func refreshHomepage() async {
        articleManager.loadHomepageArticles()
    }
}

// MARK: - Section Components

struct TrendingArticlesSection: View {
    let articles: [NewsArticle]
    let onArticleTap: (NewsArticle) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.primary)
                
                Text("Trending Now")
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSystem.Spacing.md) {
                    ForEach(articles.prefix(5)) { article in
                        TrendingArticleCard(article: article) {
                            onArticleTap(article)
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
            }
        }
    }
}

struct CategoryArticlesSection: View {
    let category: NewsCategory
    let articles: [NewsArticle]
    let onArticleTap: (NewsArticle) -> Void
    let onSeeAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            CategorySectionHeader(
                category: category,
                articleCount: articles.count,
                onSeeAll: onSeeAll
            )
            
            CategoryArticleGrid(
                articles: Array(articles.prefix(4)),
                onArticleTap: onArticleTap,
                onLike: { _ in },
                onShare: { _ in },
                onBookmark: { _ in }
            )
        }
    }
}

struct FeedArticlesSection: View {
    let articles: [NewsArticle]
    let onArticleTap: (NewsArticle) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack {
                Image(systemName: "newspaper")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.primary)
                
                Text("Latest News")
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            
            LazyVStack(spacing: DesignSystem.Spacing.sm) {
                ForEach(articles.prefix(10)) { article in
                    StandardArticleCard(
                        article: article,
                        onTap: {
                            onArticleTap(article)
                        },
                        onLike: { _ in },
                        onShare: { _ in },
                        onBookmark: { _ in }
                    )
                    .padding(.horizontal, DesignSystem.Spacing.md)
                }
            }
        }
    }
}

// MARK: - Supporting Components

struct TrendingArticleCard: View {
    let article: NewsArticle
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                // Image
                AsyncImage(url: article.imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(DesignSystem.Colors.backgroundSecondary)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 24, weight: .light))
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                        )
                }
                .frame(width: 200, height: 112)
                .clipped()
                .cornerRadius(DesignSystem.Spacing.sm)
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    // Category
                    HStack {
                        Image(systemName: article.category.icon)
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.primary)
                        
                        Text(article.category.displayName)
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.primary)
                        
                        Spacer()
                    }
                    
                    // Title
                    Text(article.title)
                        .font(DesignSystem.Typography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Meta
                    HStack {
                        Text(article.timeAgo)
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                        
                        Spacer()
                        
                        Text("\(article.readingTime) min")
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 200)
        .padding(DesignSystem.Spacing.sm)
        .background(Color(.systemBackground))
        .cornerRadius(DesignSystem.Spacing.md)
        .shadow(color: DesignSystem.Colors.shadow, radius: 2, x: 0, y: 1)
    }
}

struct ErrorStateView: View {
    let error: AppError
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(DesignSystem.Colors.error)
            
            Text("Error Loading Articles")
                .font(DesignSystem.Typography.title3)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Text(error.localizedDescription)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                onRetry()
            }
            .font(DesignSystem.Typography.body)
            .fontWeight(.medium)
            .foregroundColor(DesignSystem.Colors.primary)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.sm)
            .background(
                Capsule()
                    .fill(DesignSystem.Colors.primary.opacity(0.1))
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.Spacing.xl)
    }
}

// MARK: - Preview

struct StandardizedHomepageView_Previews: PreviewProvider {
    static var previews: some View {
        StandardizedHomepageView(selectedTab: .constant(.home))
    }
}
