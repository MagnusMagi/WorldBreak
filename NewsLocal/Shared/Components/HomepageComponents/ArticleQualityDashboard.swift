//
//  ArticleQualityDashboard.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Dashboard for monitoring article quality and standards compliance
struct ArticleQualityDashboard: View {
    @ObservedObject var articleManager: HomepageArticleManager
    @State private var showingDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            // Header
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.primary)
                
                Text("Article Quality Dashboard")
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
                
                Button(action: {
                    showingDetails.toggle()
                }) {
                    Image(systemName: showingDetails ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
            }
            
            // Quality Overview
            let metrics = articleManager.getQualityMetrics()
            
            VStack(spacing: DesignSystem.Spacing.sm) {
                // Overall Grade
                HStack {
                    Text("Overall Quality")
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    
                    Spacer()
                    
                    Text(metrics.qualityGrade)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(gradeColor(metrics.qualityGrade))
                }
                
                // Key Metrics
                HStack(spacing: DesignSystem.Spacing.lg) {
                    QualityMetricCard(
                        title: "Articles",
                        value: "\(metrics.totalArticles)",
                        icon: "newspaper",
                        color: DesignSystem.Colors.primary
                    )
                    
                    QualityMetricCard(
                        title: "With Images",
                        value: "\(Int(metrics.imageCoverage * 100))%",
                        icon: "photo",
                        color: DesignSystem.Colors.success
                    )
                    
                    QualityMetricCard(
                        title: "Verified",
                        value: "\(Int(metrics.sourceVerificationRate * 100))%",
                        icon: "checkmark.shield",
                        color: DesignSystem.Colors.info
                    )
                }
                
                // Detailed Metrics (if expanded)
                if showingDetails {
                    DetailedMetricsView(metrics: metrics)
                }
            }
            .padding(DesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.Spacing.md)
                    .fill(DesignSystem.Colors.backgroundSecondary)
            )
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
    }
    
    private func gradeColor(_ grade: String) -> Color {
        switch grade {
        case "A+", "A":
            return DesignSystem.Colors.success
        case "B":
            return DesignSystem.Colors.info
        case "C":
            return DesignSystem.Colors.warning
        case "D", "F":
            return DesignSystem.Colors.error
        default:
            return DesignSystem.Colors.textSecondary
        }
    }
}

// MARK: - Quality Metric Card

struct QualityMetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(DesignSystem.Typography.title3)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Text(title)
                .font(DesignSystem.Typography.caption1)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Spacing.sm)
                .fill(color.opacity(0.1))
        )
    }
}

// MARK: - Detailed Metrics View

struct DetailedMetricsView: View {
    let metrics: HomepageQualityMetrics
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Divider()
            
            Text("Detailed Metrics")
                .font(DesignSystem.Typography.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            VStack(spacing: DesignSystem.Spacing.xs) {
                MetricRow(
                    title: "Breaking News",
                    value: "\(metrics.breakingNewsCount)",
                    target: "3-5",
                    current: metrics.breakingNewsCount,
                    range: 3...5
                )
                
                MetricRow(
                    title: "Image Coverage",
                    value: "\(Int(metrics.imageCoverage * 100))%",
                    target: "80%+",
                    current: metrics.imageCoverage,
                    range: 0.8...1.0
                )
                
                MetricRow(
                    title: "Source Verification",
                    value: "\(Int(metrics.sourceVerificationRate * 100))%",
                    target: "70%+",
                    current: metrics.sourceVerificationRate,
                    range: 0.7...1.0
                )
                
                MetricRow(
                    title: "Quality Score",
                    value: String(format: "%.2f", metrics.averageQualityScore),
                    target: "0.7+",
                    current: metrics.averageQualityScore,
                    range: 0.7...1.0
                )
            }
            
            // Last Updated
            HStack {
                Text("Last Updated")
                    .font(DesignSystem.Typography.caption1)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
                
                Spacer()
                
                Text(metrics.lastUpdated, style: .relative)
                    .font(DesignSystem.Typography.caption1)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
        }
    }
}

// MARK: - Metric Row

struct MetricRow: View {
    let title: String
    let value: String
    let target: String
    let current: Double
    let range: ClosedRange<Double>
    
    var body: some View {
        HStack {
            Text(title)
                .font(DesignSystem.Typography.caption1)
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(DesignSystem.Typography.caption1)
                .fontWeight(.medium)
                .foregroundColor(statusColor)
            
            Text("(\(target))")
                .font(DesignSystem.Typography.caption2)
                .foregroundColor(DesignSystem.Colors.textTertiary)
            
            Image(systemName: statusIcon)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(statusColor)
        }
    }
    
    private var statusColor: Color {
        if range.contains(current) {
            return DesignSystem.Colors.success
        } else if current < range.lowerBound {
            return DesignSystem.Colors.warning
        } else {
            return DesignSystem.Colors.error
        }
    }
    
    private var statusIcon: String {
        if range.contains(current) {
            return "checkmark.circle.fill"
        } else if current < range.lowerBound {
            return "exclamationmark.triangle.fill"
        } else {
            return "xmark.circle.fill"
        }
    }
}

// MARK: - Article Validation View

struct ArticleValidationView: View {
    let validationResult: HomepageArticleStandards.ArticleValidationResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack {
                Image(systemName: validationIcon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(validationColor)
                
                Text("Article Validation")
                    .font(DesignSystem.Typography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
                
                Text(validationResult.isValid ? "Valid" : "Issues")
                    .font(DesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(validationColor)
                    .padding(.horizontal, DesignSystem.Spacing.sm)
                    .padding(.vertical, DesignSystem.Spacing.xs)
                    .background(
                        Capsule()
                            .fill(validationColor.opacity(0.1))
                    )
            }
            
            if !validationResult.issues.isEmpty {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    ForEach(validationResult.issues, id: \.description) { issue in
                        HStack {
                            Image(systemName: issueIcon(for: issue.severity))
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(severityColor(for: issue.severity))
                            
                            Text(issue.description)
                                .font(DesignSystem.Typography.caption1)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        }
                    }
                }
            }
        }
        .padding(DesignSystem.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Spacing.sm)
                .fill(validationColor.opacity(0.05))
        )
    }
    
    private var validationIcon: String {
        if validationResult.isValid {
            return "checkmark.circle.fill"
        } else {
            return "exclamationmark.triangle.fill"
        }
    }
    
    private var validationColor: Color {
        if validationResult.isValid {
            return DesignSystem.Colors.success
        } else {
            return severityColor(for: validationResult.severity)
        }
    }
    
    private func severityColor(for severity: ValidationSeverity) -> Color {
        switch severity {
        case .info:
            return DesignSystem.Colors.info
        case .warning:
            return DesignSystem.Colors.warning
        case .critical:
            return DesignSystem.Colors.error
        }
    }
    
    private func issueIcon(for severity: ValidationSeverity) -> String {
        switch severity {
        case .info:
            return "info.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .critical:
            return "xmark.circle.fill"
        }
    }
}

// MARK: - Preview

struct ArticleQualityDashboard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ArticleQualityDashboard(articleManager: HomepageArticleManager())
            
            Spacer()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
