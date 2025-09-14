//
//  CategorySectionHeader.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Header component for category-based article sections
struct CategorySectionHeader: View {
    let category: NewsCategory
    let articleCount: Int
    let onSeeAll: () -> Void
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            // Category Icon and Name
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: category.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(categoryColor)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.displayName)
                        .font(DesignSystem.Typography.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    
                    Text("\(articleCount) articles")
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
            }
            
            Spacer()
            
            // See All Button
            Button(action: onSeeAll) {
                HStack(spacing: DesignSystem.Spacing.xs) {
                    Text("See All")
                        .font(DesignSystem.Typography.caption1)
                        .fontWeight(.medium)
                        .foregroundColor(categoryColor)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(categoryColor)
                }
                .padding(.horizontal, DesignSystem.Spacing.sm)
                .padding(.vertical, DesignSystem.Spacing.xs)
                .background(
                    Capsule()
                        .fill(categoryColor.opacity(0.1))
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
        .padding(.vertical, DesignSystem.Spacing.sm)
    }
    
    // MARK: - Computed Properties
    
    private var categoryColor: Color {
        switch category.id {
        case "technology":
            return DesignSystem.Colors.categoryTechnology
        case "business":
            return DesignSystem.Colors.categoryBusiness
        case "sports":
            return DesignSystem.Colors.categorySports
        case "health":
            return DesignSystem.Colors.error
        case "politics":
            return DesignSystem.Colors.primary
        case "world":
            return DesignSystem.Colors.info
        case "entertainment":
            return DesignSystem.Colors.warning
        case "science":
            return DesignSystem.Colors.success
        case "local":
            return DesignSystem.Colors.textSecondary
        default:
            return DesignSystem.Colors.primary
        }
    }
}

// MARK: - Preview

struct CategorySectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            CategorySectionHeader(
                category: .technology,
                articleCount: 42,
                onSeeAll: {}
            )
            
            CategorySectionHeader(
                category: .business,
                articleCount: 28,
                onSeeAll: {}
            )
            
            CategorySectionHeader(
                category: .sports,
                articleCount: 67,
                onSeeAll: {}
            )
            
            CategorySectionHeader(
                category: .health,
                articleCount: 23,
                onSeeAll: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
