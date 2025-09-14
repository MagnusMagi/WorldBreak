//
//  ProfileHeader.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

// MARK: - Profile Header Component

/// Standardized profile header component for ProfileView
struct ProfileHeader: View {
    let user: User
    let readingLevel: String
    let readingLevelColor: Color
    let onEditProfile: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
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
                
                // Edit Profile Button
                Button(action: onEditProfile) {
                    Image(systemName: "pencil")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.primary)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(DesignSystem.Colors.primary.opacity(0.1))
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.leading, 13)
            .padding(.trailing, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.lg)
            
            Divider()
                .background(DesignSystem.Colors.textTertiary)
        }
        .background(DesignSystem.Colors.background)
    }
}

// MARK: - Profile Header with Statistics

/// Extended profile header with quick statistics
struct ProfileHeaderWithStats: View {
    let user: User
    let readingLevel: String
    let readingLevelColor: Color
    let onEditProfile: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Header
            ProfileHeader(
                user: user,
                readingLevel: readingLevel,
                readingLevelColor: readingLevelColor,
                onEditProfile: onEditProfile
            )
            
            // Quick Stats Row
            HStack(spacing: DesignSystem.Spacing.md) {
                QuickStatItem(
                    icon: "book.fill",
                    value: "\(user.statistics.articlesRead)",
                    label: "Read",
                    color: DesignSystem.Colors.primary
                )
                
                QuickStatItem(
                    icon: "heart.fill",
                    value: "\(user.statistics.articlesLiked)",
                    label: "Liked",
                    color: DesignSystem.Colors.error
                )
                
                QuickStatItem(
                    icon: "bookmark.fill",
                    value: "\(user.statistics.articlesShared)",
                    label: "Saved",
                    color: DesignSystem.Colors.success
                )
                
                QuickStatItem(
                    icon: "flame.fill",
                    value: "\(user.statistics.readingStreak)",
                    label: "Streak",
                    color: DesignSystem.Colors.warning
                )
            }
            .padding(.leading, 13)
            .padding(.trailing, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.lg)
            .background(DesignSystem.Colors.backgroundSecondary)
            
            Divider()
                .background(DesignSystem.Colors.textTertiary)
        }
    }
}

// MARK: - Quick Stat Item

/// Quick statistics item for profile header
struct QuickStatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            Text(value)
                .font(DesignSystem.Typography.sBold)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text(label)
                .font(DesignSystem.Typography.xs)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.Spacing.xs)
    }
}

// MARK: - Preview

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            ProfileHeader(
                user: User.mock,
                readingLevel: "News Expert",
                readingLevelColor: .red,
                onEditProfile: {
                    print("Edit profile tapped")
                }
            )
            
            ProfileHeaderWithStats(
                user: User.mock,
                readingLevel: "News Expert",
                readingLevelColor: .red,
                onEditProfile: {
                    print("Edit profile tapped")
                }
            )
        }
        .background(DesignSystem.Colors.background)
    }
}
