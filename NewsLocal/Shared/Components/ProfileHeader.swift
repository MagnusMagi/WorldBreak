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
                
                // Edit Profile Button
                Button(action: onEditProfile) {
                    Image(systemName: "pencil")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.primary)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(DesignSystem.Colors.primary.opacity(0.1))
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.md)
            
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
            HStack(spacing: DesignSystem.Spacing.lg) {
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
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.md)
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
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(DesignSystem.Typography.title3)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Text(label)
                .font(DesignSystem.Typography.caption2)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
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
            
            Spacer()
        }
        .background(DesignSystem.Colors.background)
    }
}
