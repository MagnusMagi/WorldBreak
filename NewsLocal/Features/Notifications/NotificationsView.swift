//
//  NotificationsView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Notifications view for managing user notifications and alerts
struct NotificationsView: View {
    @Binding var selectedTab: TabItem
    @StateObject private var viewModel = NotificationsViewModel()
    
    var body: some View {
        StandardPageWrapper(
            title: "Notifications",
            showCategories: false,
            selectedCategory: nil,
            selectedTab: selectedTab,
            onCategorySelected: nil,
            onTabSelected: { tab in
                selectedTab = tab
            }
        ) {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.lg) {
                    // Push Notifications Section
                    NotificationsSection(
                        title: "Push Notifications",
                        icon: "bell.fill",
                        iconColor: DesignSystem.Colors.primary
                    ) {
                        VStack(spacing: DesignSystem.Spacing.md) {
                            NotificationToggleItem(
                                title: "Breaking News",
                                description: "Get notified about breaking news",
                                isOn: $viewModel.breakingNewsEnabled
                            )
                            
                            NotificationToggleItem(
                                title: "Daily Digest",
                                description: "Receive daily news summary",
                                isOn: $viewModel.dailyDigestEnabled
                            )
                            
                            NotificationToggleItem(
                                title: "Trending Topics",
                                description: "Notifications about trending topics",
                                isOn: $viewModel.trendingEnabled
                            )
                        }
                    }
                    
                    // Email Notifications Section
                    NotificationsSection(
                        title: "Email Notifications",
                        icon: "envelope.fill",
                        iconColor: DesignSystem.Colors.secondary
                    ) {
                        VStack(spacing: DesignSystem.Spacing.md) {
                            NotificationToggleItem(
                                title: "Weekly Newsletter",
                                description: "Weekly curated news roundup",
                                isOn: $viewModel.weeklyNewsletterEnabled
                            )
                            
                            NotificationToggleItem(
                                title: "Product Updates",
                                description: "News about app updates and features",
                                isOn: $viewModel.productUpdatesEnabled
                            )
                        }
                    }
                    
                    // Quiet Hours Section
                    NotificationsSection(
                        title: "Quiet Hours",
                        icon: "moon.fill",
                        iconColor: DesignSystem.Colors.textSecondary
                    ) {
                        VStack(spacing: DesignSystem.Spacing.md) {
                            QuietHoursToggleItem(
                                title: "Enable Quiet Hours",
                                description: "Disable notifications during specified hours",
                                isOn: $viewModel.quietHoursEnabled,
                                startTime: $viewModel.quietHoursStart,
                                endTime: $viewModel.quietHoursEnd
                            )
                        }
                    }
                    
                    // Notification History Section
                    if !viewModel.recentNotifications.isEmpty {
                        NotificationsSection(
                            title: "Recent Notifications",
                            icon: "clock.fill",
                            iconColor: DesignSystem.Colors.accent
                        ) {
                            VStack(spacing: DesignSystem.Spacing.sm) {
                                ForEach(viewModel.recentNotifications.prefix(5)) { notification in
                                    NotificationHistoryItem(notification: notification)
                                }
                                
                                Button("View All") {
                                    // TODO: Navigate to full notification history
                                }
                                .font(DesignSystem.Typography.callout)
                                .foregroundColor(DesignSystem.Colors.primary)
                                .padding(.top, DesignSystem.Spacing.sm)
                            }
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.sm)
            }
        }
    }
}

// MARK: - Supporting Views

struct NotificationsSection<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.title3)
                
                Text(title)
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
            }
            
            content()
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.backgroundSecondary)
        .cornerRadius(DesignSystem.CornerRadius.md)
    }
}

struct NotificationToggleItem: View {
    let title: String
    let description: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(title)
                    .font(DesignSystem.Typography.callout)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text(description)
                    .font(DesignSystem.Typography.caption1)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}

struct QuietHoursToggleItem: View {
    let title: String
    let description: String
    @Binding var isOn: Bool
    @Binding var startTime: Date
    @Binding var endTime: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(title)
                        .font(DesignSystem.Typography.callout)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    
                    Text(description)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .labelsHidden()
            }
            
            if isOn {
                HStack {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        Text("Start Time")
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                        
                        DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        Text("End Time")
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                        
                        DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
            }
        }
    }
}

struct NotificationHistoryItem: View {
    let notification: NotificationItem
    
    var body: some View {
        HStack {
            Image(systemName: notification.icon)
                .foregroundColor(notification.color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(notification.title)
                    .font(DesignSystem.Typography.callout)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .lineLimit(1)
                
                Text(notification.message)
                    .font(DesignSystem.Typography.caption1)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Text(notification.timeAgo)
                .font(DesignSystem.Typography.caption2)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .padding(.vertical, DesignSystem.Spacing.sm)
    }
}

// MARK: - Preview

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView(selectedTab: .constant(.notifications))
    }
}
