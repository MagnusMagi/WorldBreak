//
//  BreakingNewsCard.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Special article card for breaking news with urgent styling
struct BreakingNewsCard: View {
    let article: NewsArticle
    let priority: BreakingNewsAlert.Priority
    let onTap: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                // Header with Breaking News Badge
                HStack {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("BREAKING NEWS")
                            .font(DesignSystem.Typography.xs)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.sm)
                    .padding(.vertical, DesignSystem.Spacing.xs)
                    .background(
                        Capsule()
                            .fill(priorityColor)
                    )
                    
                    Spacer()
                    
                    // Priority Indicator
                    HStack(spacing: 2) {
                        Circle()
                            .fill(priorityColor)
                            .frame(width: 6, height: 6)
                        
                        Text(priority.displayName.uppercased())
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(priorityColor)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.xs)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(priorityColor.opacity(0.1))
                    )
                    
                    // Dismiss Button
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Content
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
                    .frame(width: 100, height: 75)
                    .clipped()
                    .cornerRadius(DesignSystem.Spacing.xs)
                    
                    // Text Content
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        // Category
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: article.category.icon)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(priorityColor)
                            
                            Text(article.category.displayName)
                                .font(DesignSystem.Typography.xs)
                                .fontWeight(.medium)
                                .foregroundColor(priorityColor)
                        }
                        .padding(.horizontal, DesignSystem.Spacing.xs)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(priorityColor.opacity(0.1))
                        )
                        
                        // Title
                        Text(article.title)
                            .font(DesignSystem.Typography.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        
                        // Source and Time
                        HStack {
                            Text(article.source.name)
                                .font(DesignSystem.Typography.xs)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            
                            Text("•")
                                .font(DesignSystem.Typography.xs)
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                            
                            Text(article.timeAgo)
                                .font(DesignSystem.Typography.xs)
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                            
                            Spacer()
                            
                            Text("\(article.readingTime) min")
                                .font(DesignSystem.Typography.xs)
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                        }
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(DesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Spacing.md)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Spacing.md)
                        .stroke(priorityColor, lineWidth: 2)
                )
        )
        .shadow(color: priorityColor.opacity(0.3), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Computed Properties
    
    private var priorityColor: Color {
        switch priority {
        case .low:
            return DesignSystem.Colors.success
        case .medium:
            return DesignSystem.Colors.warning
        case .high:
            return DesignSystem.Colors.error
        case .critical:
            return DesignSystem.Colors.breakingNews
        }
    }
}

// MARK: - Preview

struct BreakingNewsCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            BreakingNewsCard(
                article: NewsArticle(
                    id: "breaking-critical",
                    title: "CRITICAL: Major Security Breach Detected in Government Systems",
                    content: "Critical security breach content...",
                    summary: "A major security breach has been detected in government systems affecting multiple agencies.",
                    author: "Security Team",
                    source: NewsSource(name: "Security News Network"),
                    publishedAt: Date(),
                    category: .technology,
                    imageUrl: URL(string: "https://images.unsplash.com/photo-1563986768609-322da13575f3?w=800"),
                    articleUrl: URL(string: "https://example.com")!,
                    isBreaking: true
                ),
                priority: .critical,
                onTap: {},
                onDismiss: {}
            )
            
            BreakingNewsCard(
                article: NewsArticle(
                    id: "breaking-high",
                    title: "High Priority: Economic Policy Changes Announced",
                    content: "High priority news content...",
                    summary: "Important economic policy changes announced by government officials.",
                    author: "Economic Team",
                    source: NewsSource(name: "Economic News Network"),
                    publishedAt: Date(),
                    category: .business,
                    imageUrl: URL(string: "https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?w=800"),
                    articleUrl: URL(string: "https://example.com")!,
                    isBreaking: true
                ),
                priority: .high,
                onTap: {},
                onDismiss: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
