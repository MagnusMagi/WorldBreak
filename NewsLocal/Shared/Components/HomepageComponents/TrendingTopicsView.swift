//
//  TrendingTopicsView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Horizontal scrolling trending topics section
struct TrendingTopicsView: View {
    let trendingTopics: [TrendingTopic]
    let onTopicSelected: (TrendingTopic) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            // Section Header
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.primary)
                
                Text("Trending Topics")
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
                
                Button("See All") {
                    // TODO: Navigate to trending topics page
                }
                .font(DesignSystem.Typography.caption1)
                .foregroundColor(DesignSystem.Colors.primary)
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            
            // Trending Topics ScrollView
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    ForEach(trendingTopics) { topic in
                        TrendingTopicChip(
                            topic: topic,
                            onTap: {
                                onTopicSelected(topic)
                            }
                        )
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
            }
        }
    }
}

// MARK: - Trending Topic Chip

struct TrendingTopicChip: View {
    let topic: TrendingTopic
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DesignSystem.Spacing.xs) {
                // Trend Arrow
                Image(systemName: trendIcon)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(trendColor)
                
                // Topic Name
                Text(topic.topic)
                    .font(DesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .lineLimit(1)
                
                // Article Count
                Text("(\(topic.articleCount))")
                    .font(DesignSystem.Typography.caption2)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
            .padding(.horizontal, DesignSystem.Spacing.sm)
            .padding(.vertical, DesignSystem.Spacing.xs)
            .background(
                Capsule()
                    .fill(backgroundColor)
            )
            .overlay(
                Capsule()
                    .stroke(borderColor, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Computed Properties
    
    private var trendIcon: String {
        if topic.growth > 0 {
            return "arrow.up"
        } else if topic.growth < 0 {
            return "arrow.down"
        } else {
            return "minus"
        }
    }
    
    private var trendColor: Color {
        if topic.growth > 0 {
            return DesignSystem.Colors.success
        } else if topic.growth < 0 {
            return DesignSystem.Colors.error
        } else {
            return DesignSystem.Colors.textTertiary
        }
    }
    
    private var backgroundColor: Color {
        if let category = topic.category {
            switch category.id {
            case "technology":
                return DesignSystem.Colors.categoryTechnology.opacity(0.1)
            case "business":
                return DesignSystem.Colors.categoryBusiness.opacity(0.1)
            case "sports":
                return DesignSystem.Colors.categorySports.opacity(0.1)
            case "health":
                return DesignSystem.Colors.error.opacity(0.1)
            case "politics":
                return DesignSystem.Colors.primary.opacity(0.1)
            default:
                return DesignSystem.Colors.backgroundSecondary
            }
        }
        return DesignSystem.Colors.backgroundSecondary
    }
    
    private var borderColor: Color {
        if let category = topic.category {
            switch category.id {
            case "technology":
                return DesignSystem.Colors.categoryTechnology.opacity(0.3)
            case "business":
                return DesignSystem.Colors.categoryBusiness.opacity(0.3)
            case "sports":
                return DesignSystem.Colors.categorySports.opacity(0.3)
            case "health":
                return DesignSystem.Colors.error.opacity(0.3)
            case "politics":
                return DesignSystem.Colors.primary.opacity(0.3)
            default:
                return DesignSystem.Colors.border
            }
        }
        return DesignSystem.Colors.border
    }
}

// MARK: - Preview

struct TrendingTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingTopicsView(
            trendingTopics: [
                TrendingTopic(
                    topic: "Artificial Intelligence",
                    category: .technology,
                    popularity: 95.5,
                    growth: 12.3,
                    articleCount: 42
                ),
                TrendingTopic(
                    topic: "Climate Change",
                    category: .world,
                    popularity: 88.2,
                    growth: 8.7,
                    articleCount: 28
                ),
                TrendingTopic(
                    topic: "Stock Market",
                    category: .business,
                    popularity: 76.8,
                    growth: -3.2,
                    articleCount: 35
                ),
                TrendingTopic(
                    topic: "Olympics 2024",
                    category: .sports,
                    popularity: 92.1,
                    growth: 15.6,
                    articleCount: 67
                ),
                TrendingTopic(
                    topic: "Healthcare Reform",
                    category: .health,
                    popularity: 71.3,
                    growth: 5.4,
                    articleCount: 23
                )
            ],
            onTopicSelected: { _ in }
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
