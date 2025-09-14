//
//  StandardizedHeroArticleCard.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Standardized hero article card that follows design standards and quality guidelines
struct StandardizedHeroArticleCard: View {
    let article: NewsArticle
    let heroType: HeroArticleStandards.HeroArticleType
    let validationResult: HeroArticleStandards.ValidationResult?
    let onTap: () -> Void
    
    @State private var showingQualityDetails = false
    
    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottomLeading) {
                // Background Image
                AsyncImage(url: article.imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(HeroArticleStandards.Layout.aspectRatio, contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(HeroArticleStandards.Colors.placeholderGradient)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        )
                }
                .frame(height: HeroArticleStandards.Layout.standardHeight)
                .clipped()
                
                // Gradient Overlay
                LinearGradient(
                    colors: HeroArticleStandards.Colors.gradientColors,
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Content
                VStack(alignment: .leading, spacing: HeroArticleStandards.Spacing.titleSpacing) {
                    // Top Badges
                    HStack(spacing: HeroArticleStandards.Spacing.badgeSpacing) {
                        // Breaking/Type Badge
                        if article.isBreaking || heroType == .breaking {
                            BreakingBadge(type: heroType)
                        }
                        
                        // Quality Indicator
                        if let result = validationResult {
                            QualityIndicator(result: result)
                        }
                        
                        Spacer()
                    }
                    
                    // Category Tag
                    CategoryTag(category: article.category)
                    
                    Spacer()
                    
                    // Title
                    Text(article.title)
                        .font(HeroArticleStandards.Typography.titleFont)
                        .fontWeight(HeroArticleStandards.Typography.titleWeight)
                        .foregroundColor(HeroArticleStandards.Colors.textColor)
                        .lineLimit(HeroArticleStandards.Typography.titleLineLimit)
                        .multilineTextAlignment(.leading)
                    
                    // Meta Information
                    MetaInformation(article: article)
                }
                .padding(HeroArticleStandards.Spacing.contentPadding)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color(.systemBackground))
        .cornerRadius(HeroArticleStandards.Layout.cornerRadius)
        .shadow(
            color: DesignSystem.Colors.shadow,
            radius: HeroArticleStandards.Layout.shadowRadius,
            x: HeroArticleStandards.Layout.shadowOffset.width,
            y: HeroArticleStandards.Layout.shadowOffset.height
        )
        .onTapGesture {
            if showingQualityDetails {
                showingQualityDetails = false
            } else {
                onTap()
            }
        }
        .onLongPressGesture {
            showingQualityDetails = true
        }
        .sheet(isPresented: $showingQualityDetails) {
            QualityDetailsSheet(
                article: article,
                validationResult: validationResult,
                heroType: heroType
            )
        }
    }
}

// MARK: - Supporting Views

struct BreakingBadge: View {
    let type: HeroArticleStandards.HeroArticleType
    
    var body: some View {
        let styling = HeroArticleStandards.styling(for: type)
        
        HStack(spacing: HeroArticleStandards.Spacing.elementSpacing) {
            Image(systemName: type == .breaking ? "flame.fill" : "star.fill")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
            
            Text(styling.badgeText)
                .font(HeroArticleStandards.Typography.breakingFont)
                .fontWeight(HeroArticleStandards.Typography.breakingWeight)
                .foregroundColor(.white)
        }
        .padding(.horizontal, DesignSystem.Spacing.sm)
        .padding(.vertical, DesignSystem.Spacing.xs)
        .background(
            Capsule()
                .fill(styling.badgeColor)
        )
    }
}

struct QualityIndicator: View {
    let result: HeroArticleStandards.ValidationResult
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(result.qualityLevel.color)
                .frame(width: 8, height: 8)
            
            Text(result.qualityLevel.displayName)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.horizontal, DesignSystem.Spacing.xs)
        .padding(.vertical, 2)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.3))
        )
    }
}

struct CategoryTag: View {
    let category: NewsCategory
    
    var body: some View {
        HStack(spacing: HeroArticleStandards.Spacing.elementSpacing) {
            Image(systemName: category.icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
            
            Text(category.displayName)
                .font(HeroArticleStandards.Typography.categoryFont)
                .fontWeight(HeroArticleStandards.Typography.categoryWeight)
                .foregroundColor(.white)
        }
        .padding(.horizontal, DesignSystem.Spacing.sm)
        .padding(.vertical, DesignSystem.Spacing.xs)
        .background(
            Capsule()
                .fill(HeroArticleStandards.Colors.categoryBackground)
        )
    }
}

struct MetaInformation: View {
    let article: NewsArticle
    
    var body: some View {
        HStack(spacing: HeroArticleStandards.Spacing.metaSpacing) {
            // Source
            HStack(spacing: HeroArticleStandards.Spacing.elementSpacing) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 6, height: 6)
                
                Text(article.source.name)
                    .font(HeroArticleStandards.Typography.metaFont)
                    .fontWeight(HeroArticleStandards.Typography.metaWeight)
                    .foregroundColor(HeroArticleStandards.Colors.textColor)
            }
            
            Spacer()
            
            // Time and Read Time
            HStack(spacing: DesignSystem.Spacing.sm) {
                Text(article.timeAgo)
                    .font(HeroArticleStandards.Typography.metaFont)
                    .foregroundColor(HeroArticleStandards.Colors.metaTextColor)
                
                Text("•")
                    .font(HeroArticleStandards.Typography.metaFont)
                    .foregroundColor(HeroArticleStandards.Colors.separatorColor)
                
                Text("\(article.readingTime) min read")
                    .font(HeroArticleStandards.Typography.metaFont)
                    .foregroundColor(HeroArticleStandards.Colors.metaTextColor)
            }
        }
    }
}

// MARK: - Quality Details Sheet

struct QualityDetailsSheet: View {
    let article: NewsArticle
    let validationResult: HeroArticleStandards.ValidationResult?
    let heroType: HeroArticleStandards.HeroArticleType
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                    // Header
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("Hero Article Quality")
                            .font(DesignSystem.Typography.title2)
                            .fontWeight(.bold)
                        
                        Text("Detailed analysis of article quality and standards compliance")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                    
                    // Quality Score
                    if let result = validationResult {
                        QualityScoreCard(result: result)
                        
                        // Issues
                        if !result.issues.isEmpty {
                            IssuesList(issues: result.issues)
                        }
                        
                        // Recommendations
                        if !result.recommendations.isEmpty {
                            RecommendationsList(recommendations: result.recommendations)
                        }
                    } else {
                        Text("No validation data available")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                    
                    // Article Details
                    ArticleDetailsCard(article: article, heroType: heroType)
                }
                .padding()
            }
            .navigationTitle("Quality Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct QualityScoreCard: View {
    let result: HeroArticleStandards.ValidationResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack {
                Text("Quality Score")
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(Int(result.score))/100")
                    .font(DesignSystem.Typography.title2)
                    .fontWeight(.bold)
                    .foregroundColor(result.qualityLevel.color)
            }
            
            ProgressView(value: result.score, total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: result.qualityLevel.color))
            
            Text(result.qualityLevel.displayName)
                .font(DesignSystem.Typography.body)
                .foregroundColor(result.qualityLevel.color)
                .fontWeight(.medium)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Spacing.sm)
                .fill(Color(.systemGray6))
        )
    }
}

struct IssuesList: View {
    let issues: [HeroArticleStandards.ValidationIssue]
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("Issues Found")
                .font(DesignSystem.Typography.title3)
                .fontWeight(.semibold)
            
            ForEach(issues, id: \.rawValue) { issue in
                HStack {
                    Circle()
                        .fill(issue.severity.color)
                        .frame(width: 8, height: 8)
                    
                    Text(issue.displayName)
                        .font(DesignSystem.Typography.body)
                    
                    Spacer()
                    
                    Text(issue.severity.displayName)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(issue.severity.color)
                        .fontWeight(.medium)
                }
                .padding(.vertical, DesignSystem.Spacing.xs)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Spacing.sm)
                .fill(Color(.systemGray6))
        )
    }
}

struct RecommendationsList: View {
    let recommendations: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("Recommendations")
                .font(DesignSystem.Typography.title3)
                .fontWeight(.semibold)
            
            ForEach(Array(recommendations.enumerated()), id: \.offset) { index, recommendation in
                HStack(alignment: .top) {
                    Text("\(index + 1).")
                        .font(DesignSystem.Typography.body)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    Text(recommendation)
                        .font(DesignSystem.Typography.body)
                    
                    Spacer()
                }
                .padding(.vertical, DesignSystem.Spacing.xs)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Spacing.sm)
                .fill(Color(.systemGray6))
        )
    }
}

struct ArticleDetailsCard: View {
    let article: NewsArticle
    let heroType: HeroArticleStandards.HeroArticleType
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("Article Details")
                .font(DesignSystem.Typography.title3)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                DetailRow(label: "Type", value: heroType.displayName)
                DetailRow(label: "Category", value: article.category.displayName)
                DetailRow(label: "Source", value: article.source.name)
                DetailRow(label: "Credibility", value: "\(Int(article.source.credibilityScore * 100))%")
                DetailRow(label: "Published", value: article.publishedAt.formatted(date: .abbreviated, time: .shortened))
                DetailRow(label: "Reading Time", value: "\(article.readingTime) min")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Spacing.sm)
                .fill(Color(.systemGray6))
        )
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(DesignSystem.Typography.body)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Preview

struct StandardizedHeroArticleCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            StandardizedHeroArticleCard(
                article: NewsArticle.mock,
                heroType: .featured,
                validationResult: HeroArticleStandards.validateHeroArticle(NewsArticle.mock),
                onTap: {}
            )
            
            StandardizedHeroArticleCard(
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
                heroType: .breaking,
                validationResult: HeroArticleStandards.validateHeroArticle(NewsArticle.mock),
                onTap: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
