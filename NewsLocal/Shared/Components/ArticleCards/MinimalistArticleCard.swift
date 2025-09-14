//
//  MinimalistArticleCard.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Minimalist article card with clean design and reduced visual clutter
struct MinimalistArticleCard: View {
    let article: NewsArticle
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                // Title - Clean and prominent
                Text(article.title)
                    .font(DesignSystem.Typography.body)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .multilineTextAlignment(.leading)
                
                // Meta information - Minimal and subtle
                HStack(spacing: DesignSystem.Spacing.sm) {
                    // Source
                    Text(article.source.name)
                        .font(DesignSystem.Typography.xs)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                    
                    // Separator
                    Text("•")
                        .font(DesignSystem.Typography.xs)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                    
                    // Time
                    Text(article.timeAgo)
                        .font(DesignSystem.Typography.xs)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                    
                    // Reading time
                    Text("•")
                        .font(DesignSystem.Typography.xs)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                    
                    Text("\(article.readingTime) min read")
                        .font(DesignSystem.Typography.xs)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                    
                    Spacer()
                }
            }
            .padding(.vertical, DesignSystem.Spacing.md)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .background(Color(.systemBackground))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Minimalist compact article card for horizontal lists
struct MinimalistCompactArticleCard: View {
    let article: NewsArticle
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
                // Content
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    // Title
                    Text(article.title)
                        .font(DesignSystem.Typography.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Meta information
                    HStack(spacing: DesignSystem.Spacing.xs) {
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
                
                // Minimal thumbnail
                AsyncImage(url: article.imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(DesignSystem.Colors.backgroundSecondary)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                        )
                }
                .frame(width: 80, height: 45)
                .clipped()
                .cornerRadius(DesignSystem.Spacing.xs)
            }
            .padding(.vertical, DesignSystem.Spacing.sm)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .background(Color(.systemBackground))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Minimalist section header
struct MinimalistSectionHeader: View {
    let title: String
    let onSeeAll: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(title)
                .font(DesignSystem.Typography.title3)
                .fontWeight(.regular)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Spacer()
            
            if let onSeeAll = onSeeAll {
                Button("See All", action: onSeeAll)
                    .font(DesignSystem.Typography.xs)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.vertical, DesignSystem.Spacing.sm)
    }
}

// MARK: - Preview

struct MinimalistArticleCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            // Minimalist section header
            MinimalistSectionHeader(title: "Latest News") {
                // See all action
            }
            
            Divider()
                .background(DesignSystem.Colors.border)
            
            // Article cards
            VStack(spacing: 0) {
                MinimalistArticleCard(
                    article: NewsArticle.mock,
                    onTap: {}
                )
                
                Divider()
                    .background(DesignSystem.Colors.border)
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                
                MinimalistArticleCard(
                    article: NewsArticle(
                        id: "minimalist-1",
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
                    onTap: {}
                )
                
                Divider()
                    .background(DesignSystem.Colors.border)
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                
                MinimalistCompactArticleCard(
                    article: NewsArticle.mock,
                    onTap: {}
                )
            }
        }
        .background(Color(.systemBackground))
        .previewLayout(.sizeThatFits)
    }
}
