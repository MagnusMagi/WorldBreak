//
//  PullToRefreshView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Custom pull-to-refresh component with smooth animations
struct PullToRefreshView: View {
    let onRefresh: () async -> Void
    @State private var isRefreshing = false
    @State private var pullOffset: CGFloat = 0
    @State private var isPulling = false
    
    private let threshold: CGFloat = 80
    
    var body: some View {
        VStack(spacing: 0) {
            // Refresh Indicator
            if isRefreshing {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: DesignSystem.Colors.primary))
                    
                    Text("Refreshing...")
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
                .padding(.vertical, DesignSystem.Spacing.md)
                .frame(maxWidth: .infinity)
                .background(DesignSystem.Colors.background)
            } else if isPulling {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.primary)
                        .rotationEffect(.degrees(pullOffset > threshold ? 180 : 0))
                        .animation(.easeInOut(duration: 0.2), value: pullOffset)
                    
                    Text(pullOffset > threshold ? "Release to refresh" : "Pull to refresh")
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
                .padding(.vertical, DesignSystem.Spacing.md)
                .frame(maxWidth: .infinity)
                .background(DesignSystem.Colors.background)
                .opacity(min(pullOffset / threshold, 1.0))
            }
        }
    }
    
    // MARK: - Public Methods
    
    func handlePullOffset(_ offset: CGFloat) {
        pullOffset = offset
        isPulling = offset > 0 && !isRefreshing
    }
    
    func startRefresh() async {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        isPulling = false
        
        await onRefresh()
        
        withAnimation(.easeOut(duration: 0.3)) {
            isRefreshing = false
            pullOffset = 0
        }
    }
    
    func shouldTriggerRefresh() -> Bool {
        return pullOffset > threshold && !isRefreshing
    }
}

// MARK: - Loading Skeleton Components

struct ArticleCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            // Image skeleton
            Rectangle()
                .fill(DesignSystem.Colors.backgroundSecondary)
                .frame(height: 200)
                .cornerRadius(DesignSystem.Spacing.sm)
                .shimmer()
            
            // Content skeleton
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                // Title skeleton
                Rectangle()
                    .fill(DesignSystem.Colors.backgroundSecondary)
                    .frame(height: 20)
                    .cornerRadius(4)
                    .shimmer()
                
                Rectangle()
                    .fill(DesignSystem.Colors.backgroundSecondary)
                    .frame(height: 20)
                    .cornerRadius(4)
                    .shimmer()
                
                // Summary skeleton
                Rectangle()
                    .fill(DesignSystem.Colors.backgroundSecondary)
                    .frame(height: 16)
                    .cornerRadius(4)
                    .shimmer()
                
                Rectangle()
                    .fill(DesignSystem.Colors.backgroundSecondary)
                    .frame(height: 16)
                    .cornerRadius(4)
                    .shimmer()
                
                // Meta skeleton
                HStack {
                    Rectangle()
                        .fill(DesignSystem.Colors.backgroundSecondary)
                        .frame(width: 80, height: 12)
                        .cornerRadius(6)
                        .shimmer()
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(DesignSystem.Colors.backgroundSecondary)
                        .frame(width: 60, height: 12)
                        .cornerRadius(6)
                        .shimmer()
                }
            }
            .padding(DesignSystem.Spacing.md)
        }
        .background(Color(.systemBackground))
        .cornerRadius(DesignSystem.Spacing.md)
        .shadow(color: DesignSystem.Colors.shadow, radius: 2, x: 0, y: 1)
    }
}

struct CompactArticleSkeleton: View {
    var body: some View {
        HStack(alignment: .center, spacing: DesignSystem.Spacing.sm) {
            // Thumbnail skeleton
            Rectangle()
                .fill(DesignSystem.Colors.backgroundSecondary)
                .frame(width: 60, height: 60)
                .cornerRadius(DesignSystem.Spacing.xs)
                .shimmer()
            
            // Content skeleton
            VStack(alignment: .leading, spacing: 4) {
                Rectangle()
                    .fill(DesignSystem.Colors.backgroundSecondary)
                    .frame(height: 12)
                    .cornerRadius(6)
                    .shimmer()
                
                Rectangle()
                    .fill(DesignSystem.Colors.backgroundSecondary)
                    .frame(height: 16)
                    .cornerRadius(4)
                    .shimmer()
                
                Rectangle()
                    .fill(DesignSystem.Colors.backgroundSecondary)
                    .frame(height: 16)
                    .cornerRadius(4)
                    .shimmer()
                
                Rectangle()
                    .fill(DesignSystem.Colors.backgroundSecondary)
                    .frame(height: 12)
                    .cornerRadius(6)
                    .shimmer()
            }
            
            Spacer()
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
        .padding(.vertical, DesignSystem.Spacing.sm)
        .background(Color(.systemBackground))
        .cornerRadius(DesignSystem.Spacing.sm)
        .shadow(color: DesignSystem.Colors.shadow, radius: 1, x: 0, y: 1)
    }
}

// MARK: - Shimmer Effect

extension View {
    func shimmer() -> some View {
        self.overlay(
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(0.3),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .rotationEffect(.degrees(30))
                .offset(x: -200)
                .animation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false),
                    value: UUID()
                )
        )
        .clipped()
    }
}

// MARK: - Preview

struct PullToRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            PullToRefreshView {
                // Simulate refresh
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
            
            ArticleCardSkeleton()
            
            CompactArticleSkeleton()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
