//
//  ActiveFiltersBar.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Bar showing active filters with clear and edit options
struct ActiveFiltersBar: View {
    let filterCount: Int
    let onClearFilters: () -> Void
    let onShowFilters: () -> Void
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            Image(systemName: "line.3.horizontal.decrease")
                .font(.caption)
                .foregroundColor(DesignSystem.Colors.primary)
            
            Text("\(filterCount) filter\(filterCount == 1 ? "" : "s") applied")
                .font(DesignSystem.Typography.caption1)
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            Spacer()
            
            HStack(spacing: DesignSystem.Spacing.sm) {
                Button("Edit") {
                    onShowFilters()
                }
                .font(DesignSystem.Typography.caption1)
                .foregroundColor(DesignSystem.Colors.primary)
                
                Button("Clear") {
                    onClearFilters()
                }
                .font(DesignSystem.Typography.caption1)
                .foregroundColor(DesignSystem.Colors.error)
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
        .padding(.vertical, DesignSystem.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                .fill(DesignSystem.Colors.primary.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                        .stroke(DesignSystem.Colors.primary.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview

struct ActiveFiltersBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            ActiveFiltersBar(
                filterCount: 1,
                onClearFilters: {},
                onShowFilters: {}
            )
            
            ActiveFiltersBar(
                filterCount: 3,
                onClearFilters: {},
                onShowFilters: {}
            )
        }
        .padding()
    }
}
