//
//  StandardArticleCard.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Medium-sized article card for standard news feed
struct StandardArticleCard: View {
    let article: NewsArticle
    let onTap: () -> Void
    let onLike: () -> Void
    let onShare: () -> Void
    let onBookmark: () -> Void
    
    @State private var isLiked = false
    @State private var isBookmarked = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
                // Image
                AsyncImage(url: article.imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(4/3, contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(DesignSystem.Colors.backgroundSecondary)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 24, weight: .light))
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                        )
                }
                .frame(width: 120, height: 90)
                .clipped()
                .cornerRadius(DesignSystem.Spacing.sm)
                
                // Content
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    // Category and Breaking Badge
                    HStack {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: article.category.icon)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.primary)
                            
                            Text(article.category.displayName)
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
                        
                        if article.isBreaking {
                            HStack(spacing: 2) {
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
                        
                        Spacer()
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
                    
                    Spacer()
                    
                    // Meta Information and Actions
                    HStack {
                        // Source and Time
                        VStack(alignment: .leading, spacing: 2) {
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
                            }
                        }
                        
                        Spacer()
                        
                        // Action Buttons
                        HStack(spacing: DesignSystem.Spacing.sm) {
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
        }
        .buttonStyle(PlainButtonStyle())
        .padding(DesignSystem.Spacing.md)
        .background(Color(.systemBackground))
        .cornerRadius(DesignSystem.Spacing.md)
        .shadow(color: DesignSystem.Colors.shadow, radius: 2, x: 0, y: 1)
    }
}

// MARK: - Preview

struct StandardArticleCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            StandardArticleCard(
                article: NewsArticle.mock,
                onTap: {},
                onLike: {},
                onShare: {},
                onBookmark: {}
            )
            
            StandardArticleCard(
                article: NewsArticle(
                    id: "breaking-news-2",
                    title: "Breaking: Major Economic Policy Changes Announced by Government Officials",
                    content: "Breaking news content...",
                    summary: "Major economic policy changes announced by government officials affecting multiple sectors.",
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
                onShare: {},
                onBookmark: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
