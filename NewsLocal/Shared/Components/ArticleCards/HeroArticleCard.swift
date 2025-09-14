//
//  HeroArticleCard.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Large featured article card for homepage hero section
struct HeroArticleCard: View {
    let article: NewsArticle
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottomLeading) {
                // Background Image
                AsyncImage(url: article.imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [DesignSystem.Colors.primary.opacity(0.3), DesignSystem.Colors.primary.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        )
                }
                .frame(height: 280)
                .clipped()
                
                // Gradient Overlay
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.black.opacity(0.3),
                        Color.black.opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Content
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    // Breaking News Badge
                    if article.isBreaking {
                        HStack {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("BREAKING")
                                .font(DesignSystem.Typography.xs)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, DesignSystem.Spacing.sm)
                        .padding(.vertical, DesignSystem.Spacing.xs)
                        .background(
                            Capsule()
                                .fill(DesignSystem.Colors.breakingNews)
                        )
                    }
                    
                    // Category Tag
                    HStack {
                        Image(systemName: article.category.icon)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                        
                        Text(article.category.displayName)
                            .font(DesignSystem.Typography.xs)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.sm)
                    .padding(.vertical, DesignSystem.Spacing.xs)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.2))
                    )
                    
                    Spacer()
                    
                    // Title
                    Text(article.title)
                        .font(DesignSystem.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    // Meta Information
                    HStack(spacing: DesignSystem.Spacing.md) {
                        // Source
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 6, height: 6)
                            
                            Text(article.source.name)
                                .font(DesignSystem.Typography.xs)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Time and Read Time
                        HStack(spacing: DesignSystem.Spacing.sm) {
                            Text(article.timeAgo)
                                .font(DesignSystem.Typography.xs)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("•")
                                .font(DesignSystem.Typography.xs)
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("\(article.readingTime) min read")
                                .font(DesignSystem.Typography.xs)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                .padding(DesignSystem.Spacing.lg)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color(.systemBackground))
        .cornerRadius(DesignSystem.Spacing.md)
        .shadow(color: DesignSystem.Colors.shadow, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Preview

struct HeroArticleCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            HeroArticleCard(
                article: NewsArticle.mock,
                onTap: {}
            )
            
            HeroArticleCard(
                article: NewsArticle(
                    id: "breaking-news",
                    title: "Breaking: Major Economic Policy Changes Announced",
                    content: "Breaking news content...",
                    summary: "Major economic policy changes announced by government officials.",
                    author: "Breaking News Team",
                    source: NewsSource(name: "Breaking News Network"),
                    publishedAt: Date(),
                    category: .politics,
                    imageUrl: URL(string: "https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?w=800"),
                    articleUrl: URL(string: "https://example.com")!,
                    isBreaking: true
                ),
                onTap: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
