//
//  CategoryArticleGrid.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Grid layout for articles within a specific category
struct CategoryArticleGrid: View {
    let articles: [NewsArticle]
    let onArticleTap: (NewsArticle) -> Void
    let onLike: (NewsArticle) -> Void
    let onShare: (NewsArticle) -> Void
    let onBookmark: (NewsArticle) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
                ForEach(articles) { article in
                    CategoryArticleCard(
                        article: article,
                        onTap: {
                            onArticleTap(article)
                        },
                        onLike: {
                            onLike(article)
                        },
                        onShare: {
                            onShare(article)
                        },
                        onBookmark: {
                            onBookmark(article)
                        }
                    )
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
        }
    }
}

// MARK: - Category Article Card

struct CategoryArticleCard: View {
    let article: NewsArticle
    let onTap: () -> Void
    let onLike: () -> Void
    let onShare: () -> Void
    let onBookmark: () -> Void
    
    @State private var isLiked = false
    @State private var isBookmarked = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
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
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    // Breaking News Badge
                    if article.isBreaking {
                        HStack {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(DesignSystem.Colors.breakingNews)
                            
                            Text("BREAKING")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(DesignSystem.Colors.breakingNews)
                        }
                        .padding(.horizontal, DesignSystem.Spacing.xs)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(DesignSystem.Colors.breakingNews.opacity(0.1))
                        )
                    }
                    
                    // Title
                    Text(article.title)
                        .font(DesignSystem.Typography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    // Meta Information
                    HStack {
                        Text(article.timeAgo)
                            .font(DesignSystem.Typography.xs)
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                        
                        Text("•")
                            .font(DesignSystem.Typography.xs)
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                        
                        Text(article.source.name)
                            .font(DesignSystem.Typography.xs)
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text("\(article.readingTime) min")
                            .font(DesignSystem.Typography.xs)
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                    }
                    
                    // Action Buttons
                    HStack {
                        // Like Button
                        Button(action: {
                            isLiked.toggle()
                            onLike()
                        }) {
                            HStack(spacing: 2) {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(isLiked ? DesignSystem.Colors.error : DesignSystem.Colors.textTertiary)
                                
                                if article.likeCount > 0 {
                                    Text("\(article.likeCount)")
                                        .font(.system(size: 8, weight: .medium))
                                        .foregroundColor(DesignSystem.Colors.textTertiary)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                        
                        // Share Button
                        Button(action: onShare) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Bookmark Button
                        Button(action: {
                            isBookmarked.toggle()
                            onBookmark()
                        }) {
                            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(isBookmarked ? DesignSystem.Colors.warning : DesignSystem.Colors.textTertiary)
                        }
                        .buttonStyle(PlainButtonStyle())
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

// MARK: - Preview

struct CategoryArticleGrid_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            CategorySectionHeader(
                category: .technology,
                articleCount: 42,
                onSeeAll: {}
            )
            
            CategoryArticleGrid(
                articles: NewsArticle.mockArray,
                onArticleTap: { _ in },
                onLike: { _ in },
                onShare: { _ in },
                onBookmark: { _ in }
            )
        }
        .previewLayout(.sizeThatFits)
    }
}
