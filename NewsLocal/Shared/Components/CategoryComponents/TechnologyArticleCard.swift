//
//  TechnologyArticleCard.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Specialized article card for technology news with enhanced features
struct TechnologyArticleCard: View {
    let article: NewsArticle
    let subcategory: String?
    let onTap: () -> Void
    let onLike: () -> Void
    let onShare: () -> Void
    let onBookmark: () -> Void
    
    @State private var isLiked = false
    @State private var isBookmarked = false
    @StateObject private var categoryManager = CategoryManager()
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                // Header with subcategory and breaking badge
                HStack {
                    if let subcategory = subcategory {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: getSubcategoryIcon(for: subcategory))
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
                    
                    if article.isBreaking {
                        HStack(spacing: 2) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(DesignSystem.Colors.breakingNews)
                            
                            Text("BREAKING")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(DesignSystem.Colors.breakingNews)
                        }
                        .padding(.horizontal, DesignSystem.Spacing.xs)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(DesignSystem.Colors.breakingNews.opacity(0.1))
                        )
                    }
                    
                    Spacer()
                    
                    // Technology-specific indicators
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        if article.tags.contains("AI") || article.tags.contains("Artificial Intelligence") {
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                        
                        if article.tags.contains("Innovation") || article.tags.contains("Breakthrough") {
                            Image(systemName: "lightbulb")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.warning)
                        }
                    }
                }
                
                // Main content
                HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
                    // Image
                    AsyncImage(url: article.imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(DesignSystem.Colors.backgroundSecondary)
                            .overlay(
                                VStack(spacing: DesignSystem.Spacing.xs) {
                                    Image(systemName: "laptopcomputer")
                                        .font(.system(size: 24, weight: .light))
                                        .foregroundColor(DesignSystem.Colors.textTertiary)
                                    
                                    Text("Tech News")
                                        .font(DesignSystem.Typography.xs)
                                        .foregroundColor(DesignSystem.Colors.textTertiary)
                                }
                            )
                    }
                    .frame(width: 120, height: 68)
                    .clipped()
                    .cornerRadius(DesignSystem.Spacing.sm)
                    
                    // Content
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
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
                        
                        Spacer()
                        
                        // Technology-specific metadata
                        VStack(alignment: .leading, spacing: 2) {
                            // Source and time
                            HStack(spacing: DesignSystem.Spacing.xs) {
                                Circle()
                                    .fill(DesignSystem.Colors.primary)
                                    .frame(width: 4, height: 4)
                                
                                Text(article.source.name)
                                    .font(DesignSystem.Typography.xs)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                            }
                            
                            HStack(spacing: DesignSystem.Spacing.sm) {
                                Text(article.timeAgo)
                                    .font(DesignSystem.Typography.xs)
                                    .foregroundColor(DesignSystem.Colors.textTertiary)
                                
                                Text("•")
                                    .font(DesignSystem.Typography.xs)
                                    .foregroundColor(DesignSystem.Colors.textTertiary)
                                
                                Text("\(article.readingTime) min")
                                    .font(DesignSystem.Typography.xs)
                                    .foregroundColor(DesignSystem.Colors.textTertiary)
                                
                                // Technology reading level indicator
                                if article.readingTime > 5 {
                                    Text("•")
                                        .font(DesignSystem.Typography.xs)
                                        .foregroundColor(DesignSystem.Colors.textTertiary)
                                    
                                    Text("Technical")
                                        .font(DesignSystem.Typography.xs)
                                        .foregroundColor(DesignSystem.Colors.warning)
                                }
                            }
                        }
                    }
                }
                
                // Technology tags
                if !article.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            ForEach(article.tags.prefix(5), id: \.self) { tag in
                                Text(tag)
                                    .font(DesignSystem.Typography.xs)
                                    .foregroundColor(DesignSystem.Colors.textTertiary)
                                    .padding(.horizontal, DesignSystem.Spacing.xs)
                                    .padding(.vertical, 2)
                                    .background(
                                        Capsule()
                                            .fill(DesignSystem.Colors.backgroundSecondary)
                                    )
                            }
                        }
                        .padding(.horizontal, 1)
                    }
                }
                
                // Action buttons
                HStack {
                    Spacer()
                    
                    HStack(spacing: DesignSystem.Spacing.md) {
                        // Like Button
                        Button(action: {
                            isLiked.toggle()
                            onLike()
                        }) {
                            HStack(spacing: 2) {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(isLiked ? DesignSystem.Colors.error : DesignSystem.Colors.textTertiary)
                                
                                Text("\(article.likeCount)")
                                    .font(DesignSystem.Typography.xs)
                                    .foregroundColor(DesignSystem.Colors.textTertiary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Share Button
                        Button(action: onShare) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Bookmark Button
                        Button(action: {
                            isBookmarked.toggle()
                            onBookmark()
                        }) {
                            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(isBookmarked ? DesignSystem.Colors.warning : DesignSystem.Colors.textTertiary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(DesignSystem.Spacing.md)
        .background(Color(.systemBackground))
        .cornerRadius(DesignSystem.Spacing.md)
        .shadow(color: DesignSystem.Colors.shadow, radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Helper Methods
    
    private func getSubcategoryIcon(for subcategory: String) -> String {
        if let techSubcategory = CategoryStandards.TechnologySubcategory.allCases.first(where: { $0.displayName == subcategory }) {
            return techSubcategory.icon
        }
        return "laptopcomputer"
    }
}

// MARK: - Technology Section Header

struct TechnologySectionHeader: View {
    let subcategory: String?
    let articleCount: Int
    let onSeeAll: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "laptopcomputer")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    Text("Technology")
                        .font(DesignSystem.Typography.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    
                    if let subcategory = subcategory {
                        Text("• \(subcategory)")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                }
                
                Text("\(articleCount) articles")
                    .font(DesignSystem.Typography.xs)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
            
            Spacer()
            
            Button("See All", action: onSeeAll)
                .font(DesignSystem.Typography.xs)
                .foregroundColor(DesignSystem.Colors.primary)
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
        .padding(.vertical, DesignSystem.Spacing.sm)
    }
}

// MARK: - Preview

struct TechnologyArticleCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            TechnologyArticleCard(
                article: NewsArticle.mock,
                subcategory: "Artificial Intelligence",
                onTap: {},
                onLike: {},
                onShare: {},
                onBookmark: {}
            )
            
            TechnologyArticleCard(
                article: NewsArticle(
                    id: "tech-1",
                    title: "Revolutionary AI Breakthrough Transforms Healthcare Industry",
                    content: "Content...",
                    summary: "New AI system achieves 98% accuracy in disease diagnosis, promising to revolutionize healthcare.",
                    author: "Tech Reporter",
                    source: NewsSource(name: "Tech News"),
                    publishedAt: Date(),
                    category: .technology,
                    imageUrl: URL(string: "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800"),
                    articleUrl: URL(string: "https://example.com")!,
                    isBreaking: true,
                    tags: ["AI", "Healthcare", "Innovation", "Breakthrough", "Technology"],
                    likeCount: 42,
                    shareCount: 15
                ),
                subcategory: "Artificial Intelligence",
                onTap: {},
                onLike: {},
                onShare: {},
                onBookmark: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
