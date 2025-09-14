//
//  ProfileComponents.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

// MARK: - Profile Section Header

/// A section header for profile sections using Design System
struct ProfileSectionHeader: View {
    let title: String
    let icon: String
    let color: Color
    
    init(title: String, icon: String, color: Color = DesignSystem.Colors.primary) {
        self.title = title
        self.icon = icon
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(DesignSystem.Typography.title2_5)
                .fontWeight(.regular)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Spacer()
        }
        .padding(.vertical, DesignSystem.Spacing.sm)
        .padding(.horizontal, DesignSystem.Spacing.md)
    }
}

// MARK: - Profile List Item

/// A list item for profile sections using Design System
struct ProfileListItem: View {
    let icon: String
    let title: String
    let subtitle: String?
    let badge: String?
    let color: Color
    let action: () -> Void
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        badge: String? = nil,
        color: Color = DesignSystem.Colors.primary,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.badge = badge
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: DesignSystem.Spacing.md) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                
                // Content
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(title)
                        .font(DesignSystem.Typography.body)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .lineLimit(1)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(DesignSystem.Typography.s)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Badge
                if let badge = badge {
                    Text(badge)
                        .font(DesignSystem.Typography.xs)
                        .fontWeight(.medium)
                        .padding(.horizontal, DesignSystem.Spacing.sm)
                        .padding(.vertical, DesignSystem.Spacing.xs)
                        .background(color.opacity(0.1))
                        .foregroundColor(color)
                        .clipShape(Capsule())
                }
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
            .padding(.vertical, DesignSystem.Spacing.md)
            .padding(.horizontal, DesignSystem.Spacing.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Profile Header View

/// Compact profile header for the list using Design System
struct ProfileHeaderView: View {
    let user: User
    let readingLevel: String
    let readingLevelColor: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.lg) {
            // Profile Image
            AsyncImage(url: user.profileImageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(DesignSystem.Colors.primary.opacity(0.1))
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.primary)
                    )
            }
            .frame(width: 78, height: 78)
            .clipShape(Circle())
            .shadow(color: DesignSystem.Colors.shadow, radius: 2, x: 0, y: 1)
            
            // User Info
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                Text(user.name)
                    .font(DesignSystem.Typography.title2_5)
                    .fontWeight(.regular)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .lineLimit(1)
                
                Text(user.email)
                    .font(DesignSystem.Typography.s)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .lineLimit(1)
                
                // Reading Level Badge
                HStack(spacing: DesignSystem.Spacing.xs) {
                    Circle()
                        .fill(readingLevelColor)
                        .frame(width: 6, height: 6)
                    
                    Text(readingLevel)
                        .font(DesignSystem.Typography.xs)
                        .fontWeight(.medium)
                        .foregroundColor(readingLevelColor)
                }
                .padding(.horizontal, DesignSystem.Spacing.sm)
                .padding(.vertical, DesignSystem.Spacing.xs)
                .background(
                    Capsule()
                        .fill(readingLevelColor.opacity(0.1))
                )
            }
            
            Spacer()
        }
        .padding(.vertical, DesignSystem.Spacing.lg)
        .padding(.horizontal, DesignSystem.Spacing.md)
    }
}

// MARK: - Statistics Row

/// A row showing a single statistic using Design System
struct StatisticsRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .center, spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(DesignSystem.Typography.s)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .lineLimit(1)
            
            Spacer()
            
            Text(value)
                .font(DesignSystem.Typography.sBold)
                .fontWeight(.medium)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .lineLimit(1)
        }
        .padding(.vertical, DesignSystem.Spacing.sm)
        .padding(.horizontal, DesignSystem.Spacing.md)
    }
}

// MARK: - Preview

struct ProfileComponents_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            ProfileHeaderView(
                user: User.mock,
                readingLevel: "News Expert",
                readingLevelColor: .red
            )
            
            ProfileListItem(
                icon: "clock.fill",
                title: "Reading History",
                subtitle: "View your recent articles",
                badge: "5",
                color: .blue
            ) {
                print("Reading History tapped")
            }
            
            StatisticsRow(
                icon: "book.fill",
                title: "Articles Read",
                value: "150",
                color: .blue
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
