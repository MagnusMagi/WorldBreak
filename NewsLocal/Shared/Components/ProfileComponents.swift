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
        HStack(spacing: DesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
            
            Text(title)
                .font(DesignSystem.Typography.title3)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
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
            HStack(spacing: DesignSystem.Spacing.md) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                
                // Content
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(title)
                        .font(DesignSystem.Typography.body)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                }
                
                Spacer()
                
                // Badge
                if let badge = badge {
                    Text(badge)
                        .font(DesignSystem.Typography.caption1)
                        .fontWeight(.medium)
                        .padding(.horizontal, DesignSystem.Spacing.sm)
                        .padding(.vertical, DesignSystem.Spacing.xs)
                        .background(color.opacity(0.1))
                        .foregroundColor(color)
                        .clipShape(Capsule())
                }
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .padding(.vertical, DesignSystem.Spacing.xs)
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
        HStack(spacing: DesignSystem.Spacing.md) {
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
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.primary)
                    )
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            
            // User Info
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(user.name)
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text(user.email)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                // Reading Level Badge
                HStack(spacing: DesignSystem.Spacing.xs) {
                    Circle()
                        .fill(readingLevelColor)
                        .frame(width: 6, height: 6)
                    
                    Text(readingLevel)
                        .font(DesignSystem.Typography.caption1)
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
        .padding(.vertical, DesignSystem.Spacing.sm)
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
        HStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 20, height: 20)
            
            Text(title)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(DesignSystem.Typography.body)
                .fontWeight(.medium)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .padding(.vertical, DesignSystem.Spacing.xs)
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
