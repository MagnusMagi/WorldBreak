//
//  CacheStatisticsView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// View for displaying cache statistics and performance metrics
struct CacheStatisticsView: View {
    @ObservedObject var cacheManager: SearchCacheManager
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.lg) {
                    // Cache Overview
                    CacheOverviewCard(cacheManager: cacheManager)
                    
                    // Performance Metrics
                    PerformanceMetricsCard(cacheManager: cacheManager)
                    
                    // Cache Management
                    CacheManagementCard(cacheManager: cacheManager)
                    
                    // Memory Usage
                    MemoryUsageCard(cacheManager: cacheManager)
                }
                .padding(DesignSystem.Spacing.md)
            }
            .navigationTitle("Cache Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

// MARK: - Cache Overview Card

struct CacheOverviewCard: View {
    @ObservedObject var cacheManager: SearchCacheManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Image(systemName: "externaldrive.fill")
                    .foregroundColor(DesignSystem.Colors.primary)
                
                Text("Cache Overview")
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
            }
            
            let stats = cacheManager.getCacheStatistics()
            
            VStack(spacing: DesignSystem.Spacing.sm) {
                StatisticRow(
                    title: "Total Entries",
                    value: "\(stats.totalEntries)",
                    icon: "doc.text.fill",
                    color: DesignSystem.Colors.primary
                )
                
                StatisticRow(
                    title: "Suggestions Cached",
                    value: "\(stats.suggestionsEntries)",
                    icon: "lightbulb.fill",
                    color: DesignSystem.Colors.warning
                )
                
                StatisticRow(
                    title: "Trending Topics",
                    value: stats.trendingTopicsCached ? "Cached" : "Not Cached",
                    icon: "flame.fill",
                    color: DesignSystem.Colors.error
                )
                
                StatisticRow(
                    title: "Hit Rate",
                    value: stats.formattedHitRate,
                    icon: "target",
                    color: DesignSystem.Colors.success
                )
            }
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.backgroundSecondary)
        .cornerRadius(DesignSystem.CornerRadius.md)
    }
}

// MARK: - Performance Metrics Card

struct PerformanceMetricsCard: View {
    @ObservedObject var cacheManager: SearchCacheManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Image(systemName: "speedometer")
                    .foregroundColor(DesignSystem.Colors.info)
                
                Text("Performance Metrics")
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: DesignSystem.Spacing.sm) {
                PerformanceMetricRow(
                    title: "Cache Hit Rate",
                    value: String(format: "%.1f%%", cacheManager.cacheHitRate * 100),
                    progress: cacheManager.cacheHitRate,
                    color: DesignSystem.Colors.success
                )
                
                PerformanceMetricRow(
                    title: "Cache Size",
                    value: "\(cacheManager.cacheSize) entries",
                    progress: Double(cacheManager.cacheSize) / 100.0, // Assuming max 100
                    color: DesignSystem.Colors.warning
                )
            }
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.backgroundSecondary)
        .cornerRadius(DesignSystem.CornerRadius.md)
    }
}

// MARK: - Cache Management Card

struct CacheManagementCard: View {
    @ObservedObject var cacheManager: SearchCacheManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Image(systemName: "gear")
                    .foregroundColor(DesignSystem.Colors.secondary)
                
                Text("Cache Management")
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: DesignSystem.Spacing.sm) {
                Button(action: {
                    cacheManager.clearExpiredCache()
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Clear Expired Cache")
                        Spacer()
                    }
                }
                .secondaryButtonStyle()
                
                Button(action: {
                    cacheManager.clearCache()
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Clear All Cache")
                        Spacer()
                    }
                }
                .foregroundColor(DesignSystem.Colors.error)
                .padding(DesignSystem.Spacing.sm)
                .background(DesignSystem.Colors.error.opacity(0.1))
                .cornerRadius(DesignSystem.CornerRadius.sm)
            }
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.backgroundSecondary)
        .cornerRadius(DesignSystem.CornerRadius.md)
    }
}

// MARK: - Memory Usage Card

struct MemoryUsageCard: View {
    @ObservedObject var cacheManager: SearchCacheManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Image(systemName: "memorychip")
                    .foregroundColor(DesignSystem.Colors.accent)
                
                Text("Memory Usage")
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
            }
            
            let stats = cacheManager.getCacheStatistics()
            
            VStack(spacing: DesignSystem.Spacing.sm) {
                StatisticRow(
                    title: "Estimated Memory",
                    value: stats.formattedMemoryUsage,
                    icon: "memorychip.fill",
                    color: DesignSystem.Colors.accent
                )
                
                StatisticRow(
                    title: "Cache Efficiency",
                    value: stats.hitRate > 0.8 ? "Excellent" : stats.hitRate > 0.6 ? "Good" : "Poor",
                    icon: "checkmark.circle.fill",
                    color: stats.hitRate > 0.8 ? DesignSystem.Colors.success : stats.hitRate > 0.6 ? DesignSystem.Colors.warning : DesignSystem.Colors.error
                )
            }
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.backgroundSecondary)
        .cornerRadius(DesignSystem.CornerRadius.md)
    }
}

// MARK: - Supporting Views

struct StatisticRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(DesignSystem.Typography.body)
                .fontWeight(.medium)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
    }
}

struct PerformanceMetricRow: View {
    let title: String
    let value: String
    let progress: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
            HStack {
                Text(title)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
                
                Text(value)
                    .font(DesignSystem.Typography.body)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
    }
}

// MARK: - Preview

struct CacheStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        CacheStatisticsView(
            cacheManager: SearchCacheManager.mock,
            isPresented: .constant(true)
        )
    }
}
