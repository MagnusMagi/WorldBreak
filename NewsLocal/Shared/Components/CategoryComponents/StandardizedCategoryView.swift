//
//  StandardizedCategoryView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Standardized category view that uses the category management system
struct StandardizedCategoryView: View {
    let category: CategoryStandards.MainCategory
    let articles: [NewsArticle]
    let onArticleTap: (NewsArticle) -> Void
    let onSeeAll: () -> Void
    
    @StateObject private var categoryManager = CategoryManager()
    @State private var selectedSubcategory: String? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // Category header
            CategoryHeaderView(
                category: category,
                subcategory: selectedSubcategory,
                articleCount: articles.count,
                onSeeAll: onSeeAll,
                onSubcategorySelected: { subcategory in
                    selectedSubcategory = subcategory
                }
            )
            
            Divider()
                .background(DesignSystem.Colors.border)
            
            // Articles based on category type
            LazyVStack(spacing: 0) {
                ForEach(articles) { article in
                    ArticleCardView(
                        article: article,
                        category: category,
                        subcategory: getSubcategory(for: article),
                        onTap: { onArticleTap(article) }
                    )
                    
                    if article.id != articles.last?.id {
                        Divider()
                            .background(DesignSystem.Colors.border)
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(DesignSystem.Spacing.sm)
        .shadow(color: DesignSystem.Colors.shadow, radius: 1, x: 0, y: 1)
    }
    
    // MARK: - Helper Methods
    
    private func getSubcategory(for article: NewsArticle) -> String? {
        let classification = categoryManager.classifyArticle(article)
        return classification.subcategory
    }
}

// MARK: - Category Header View

struct CategoryHeaderView: View {
    let category: CategoryStandards.MainCategory
    let subcategory: String?
    let articleCount: Int
    let onSeeAll: () -> Void
    let onSubcategorySelected: (String?) -> Void
    
    @StateObject private var categoryManager = CategoryManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            // Main category header
            HStack {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: category.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(category.color)
                    
                    Text(category.displayName)
                        .font(DesignSystem.Typography.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    
                    Text("\(articleCount)")
                        .font(DesignSystem.Typography.xs)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                        .padding(.horizontal, DesignSystem.Spacing.xs)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(DesignSystem.Colors.backgroundSecondary)
                        )
                }
                
                Spacer()
                
                Button("See All", action: onSeeAll)
                    .font(DesignSystem.Typography.xs)
                    .foregroundColor(category.color)
            }
            
            // Subcategory filter (if applicable)
            if !getSubcategories().isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        // All subcategories option
                        Button(action: {
                            onSubcategorySelected(nil)
                        }) {
                            Text("All")
                                .font(DesignSystem.Typography.xs)
                                .foregroundColor(subcategory == nil ? .white : category.color)
                                .padding(.horizontal, DesignSystem.Spacing.sm)
                                .padding(.vertical, DesignSystem.Spacing.xs)
                                .background(
                                    Capsule()
                                        .fill(subcategory == nil ? category.color : category.color.opacity(0.1))
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Individual subcategories
                        ForEach(getSubcategories(), id: \.self) { subcategoryName in
                            Button(action: {
                                onSubcategorySelected(subcategoryName)
                            }) {
                                Text(subcategoryName)
                                    .font(DesignSystem.Typography.xs)
                                    .foregroundColor(subcategory == subcategoryName ? .white : category.color)
                                    .padding(.horizontal, DesignSystem.Spacing.sm)
                                    .padding(.vertical, DesignSystem.Spacing.xs)
                                    .background(
                                        Capsule()
                                            .fill(subcategory == subcategoryName ? category.color : category.color.opacity(0.1))
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.vertical, DesignSystem.Spacing.sm)
    }
    
    private func getSubcategories() -> [String] {
        return categoryManager.getSubcategories(for: category)
    }
}

// MARK: - Article Card View

struct ArticleCardView: View {
    let article: NewsArticle
    let category: CategoryStandards.MainCategory
    let subcategory: String?
    let onTap: () -> Void
    
    var body: some View {
        switch category {
        case .technology:
            TechnologyArticleCard(
                article: article,
                subcategory: subcategory,
                onTap: onTap,
                onLike: { /* TODO: Handle like */ },
                onShare: { /* TODO: Handle share */ },
                onBookmark: { /* TODO: Handle bookmark */ }
            )
        case .business:
            BusinessArticleCard(
                article: article,
                subcategory: subcategory,
                onTap: onTap
            )
        case .science:
            ScienceArticleCard(
                article: article,
                subcategory: subcategory,
                onTap: onTap
            )
        default:
            MinimalistArticleCard(
                article: article,
                onTap: onTap
            )
        }
    }
}

// MARK: - Business Article Card

struct BusinessArticleCard: View {
    let article: NewsArticle
    let subcategory: String?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
                // Content
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    // Subcategory badge
                    if let subcategory = subcategory {
                        HStack {
                            Text(subcategory)
                                .font(DesignSystem.Typography.xs)
                                .fontWeight(.medium)
                                .foregroundColor(DesignSystem.Colors.primary)
                                .padding(.horizontal, DesignSystem.Spacing.xs)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(DesignSystem.Colors.primary.opacity(0.1))
                                )
                            
                            Spacer()
                        }
                    }
                    
                    // Title
                    Text(article.title)
                        .font(DesignSystem.Typography.body)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Summary
                    Text(article.summary)
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    // Metadata
                    HStack(spacing: DesignSystem.Spacing.sm) {
                        Text(article.source.name)
                            .font(DesignSystem.Typography.xs)
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                        
                        Text("•")
                            .font(DesignSystem.Typography.xs)
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                        
                        Text(article.timeAgo)
                            .font(DesignSystem.Typography.xs)
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                        
                        Spacer()
                    }
                }
                
                // Thumbnail
                AsyncImage(url: article.imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(4/3, contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(DesignSystem.Colors.backgroundSecondary)
                        .overlay(
                            Image(systemName: "briefcase")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                        )
                }
                .frame(width: 80, height: 60)
                .clipped()
                .cornerRadius(DesignSystem.Spacing.xs)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, DesignSystem.Spacing.sm)
        .padding(.horizontal, DesignSystem.Spacing.lg)
    }
}

// MARK: - Science Article Card

struct ScienceArticleCard: View {
    let article: NewsArticle
    let subcategory: String?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                // Header
                HStack {
                    if let subcategory = subcategory {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "atom")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.primary)
                            
                            Text(subcategory)
                                .font(DesignSystem.Typography.xs)
                                .fontWeight(.medium)
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                        .padding(.horizontal, DesignSystem.Spacing.xs)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(DesignSystem.Colors.primary.opacity(0.1))
                        )
                    }
                    
                    Spacer()
                    
                    // Science indicators
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        if article.tags.contains("Research") || article.tags.contains("Study") {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                        
                        if article.tags.contains("Discovery") || article.tags.contains("Breakthrough") {
                            Image(systemName: "lightbulb")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.warning)
                        }
                    }
                }
                
                // Title
                Text(article.title)
                    .font(DesignSystem.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                // Summary
                Text(article.summary)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Metadata
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Text(article.source.name)
                        .font(DesignSystem.Typography.xs)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                    
                    Text("•")
                        .font(DesignSystem.Typography.xs)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                    
                    Text(article.timeAgo)
                        .font(DesignSystem.Typography.xs)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                    
                    Spacer()
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, DesignSystem.Spacing.md)
        .padding(.horizontal, DesignSystem.Spacing.lg)
    }
}

// MARK: - Preview

struct StandardizedCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            StandardizedCategoryView(
                category: .technology,
                articles: NewsArticle.mockArray,
                onArticleTap: { _ in },
                onSeeAll: {}
            )
            
            StandardizedCategoryView(
                category: .business,
                articles: NewsArticle.mockArray,
                onArticleTap: { _ in },
                onSeeAll: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
