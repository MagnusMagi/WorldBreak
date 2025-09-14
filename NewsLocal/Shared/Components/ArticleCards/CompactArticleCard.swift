//
//  CompactArticleCard.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Small horizontal article card for compact lists
struct CompactArticleCard: View {
    let article: NewsArticle
    let onTap: () -> Void
    let onLike: () -> Void
    let onBookmark: () -> Void
    
    @State private var isLiked = false
    @State private var isBookmarked = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: DesignSystem.Spacing.sm) {
                // Thumbnail Image
                AsyncImage(url: article.imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(DesignSystem.Colors.backgroundSecondary)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                        )
                }
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(DesignSystem.Spacing.xs)
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    // Category and Breaking Badge
                    HStack {
                        HStack(spacing: 2) {
                            Image(systemName: article.category.icon)
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.primary)
                            
                            Text(article.category.displayName)
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(
                            Capsule()
                                .fill(DesignSystem.Colors.primary.opacity(0.1))
                        )
                        
                        if article.isBreaking {
                            HStack(spacing: 1) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 6, weight: .bold))
                                    .foregroundColor(DesignSystem.Colors.breakingNews)
                                
                                Text("BREAKING")
                                    .font(.system(size: 6, weight: .bold))
                                    .foregroundColor(DesignSystem.Colors.breakingNews)
                            }
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(
                                Capsule()
                                    .fill(DesignSystem.Colors.breakingNews.opacity(0.1))
                            )
                        }
                        
                        Spacer()
                    }
                    
                    // Title
                    Text(article.title)
                        .font(DesignSystem.Typography.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .lineLimit(2)
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
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: DesignSystem.Spacing.xs) {
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
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, DesignSystem.Spacing.md)
        .padding(.vertical, DesignSystem.Spacing.sm)
        .background(Color(.systemBackground))
        .cornerRadius(DesignSystem.Spacing.sm)
        .shadow(color: DesignSystem.Colors.shadow, radius: 1, x: 0, y: 1)
    }
}

// MARK: - Preview

struct CompactArticleCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            CompactArticleCard(
                article: NewsArticle.mock,
                onTap: {},
                onLike: {},
                onBookmark: {}
            )
            
            CompactArticleCard(
                article: NewsArticle(
                    id: "breaking-news-3",
                    title: "Breaking: Major Economic Policy Changes Announced",
                    content: "Breaking news content...",
                    summary: "Major economic policy changes announced by government officials.",
                    author: "Breaking News Team",
                    source: NewsSource(name: "Breaking News Network"),
                    publishedAt: Date(),
                    category: .politics,
                    imageUrl: URL(string: "https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?w=800"),
                    articleUrl: URL(string: "https://example.com")!,
                    isBreaking: true,
                    likeCount: 42,
                    shareCount: 15
                ),
                onTap: {},
                onLike: {},
                onBookmark: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
