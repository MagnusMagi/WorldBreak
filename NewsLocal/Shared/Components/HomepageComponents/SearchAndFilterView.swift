//
//  SearchAndFilterView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Search and filter component for news articles
struct SearchAndFilterView: View {
    @Binding var searchText: String
    @Binding var selectedCategories: Set<NewsCategory>
    @Binding var selectedSources: Set<NewsSource>
    @Binding var sortOption: SearchFilters.SortOption
    @Binding var sortOrder: SearchFilters.SortOrder
    @Binding var dateFrom: Date?
    @Binding var dateTo: Date?
    
    @State private var isShowingFilters = false
    @State private var isShowingSortOptions = false
    
    let onSearch: () -> Void
    let onClearFilters: () -> Void
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            // Search Bar
            HStack(spacing: DesignSystem.Spacing.sm) {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                    
                    TextField("Search articles...", text: $searchText)
                        .font(DesignSystem.Typography.body)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onSubmit {
                            onSearch()
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            onSearch()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.Spacing.sm)
                        .fill(DesignSystem.Colors.backgroundSecondary)
                )
                
                // Filter Button
                Button(action: {
                    isShowingFilters.toggle()
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(hasActiveFilters ? DesignSystem.Colors.primary : DesignSystem.Colors.textTertiary)
                }
                .overlay(
                    // Filter count badge
                    Group {
                        if activeFilterCount > 0 {
                            Text("\(activeFilterCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 16, height: 16)
                                .background(DesignSystem.Colors.primary)
                                .clipShape(Circle())
                                .offset(x: 8, y: -8)
                        }
                    }
                )
            }
            
            // Filter Options
            if isShowingFilters {
                VStack(spacing: DesignSystem.Spacing.md) {
                    // Categories
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("Categories")
                            .font(DesignSystem.Typography.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: DesignSystem.Spacing.sm) {
                            ForEach(NewsCategory.allCases, id: \.id) { category in
                                CategoryFilterChip(
                                    category: category,
                                    isSelected: selectedCategories.contains(category),
                                    onToggle: {
                                        if selectedCategories.contains(category) {
                                            selectedCategories.remove(category)
                                        } else {
                                            selectedCategories.insert(category)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    
                    // Sort Options
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("Sort By")
                            .font(DesignSystem.Typography.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                        
                        HStack(spacing: DesignSystem.Spacing.sm) {
                            Menu {
                                ForEach(SearchFilters.SortOption.allCases, id: \.self) { option in
                                    Button(option.displayName) {
                                        sortOption = option
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(sortOption.displayName)
                                        .font(DesignSystem.Typography.caption1)
                                        .foregroundColor(DesignSystem.Colors.textPrimary)
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(DesignSystem.Colors.textTertiary)
                                }
                                .padding(.horizontal, DesignSystem.Spacing.sm)
                                .padding(.vertical, DesignSystem.Spacing.xs)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.Spacing.xs)
                                        .fill(DesignSystem.Colors.backgroundSecondary)
                                )
                            }
                            
                            Menu {
                                ForEach(SearchFilters.SortOrder.allCases, id: \.self) { order in
                                    Button(order.displayName) {
                                        sortOrder = order
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: sortOrder == .ascending ? "arrow.up" : "arrow.down")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(DesignSystem.Colors.textTertiary)
                                    
                                    Text(sortOrder.displayName)
                                        .font(DesignSystem.Typography.caption1)
                                        .foregroundColor(DesignSystem.Colors.textPrimary)
                                }
                                .padding(.horizontal, DesignSystem.Spacing.sm)
                                .padding(.vertical, DesignSystem.Spacing.xs)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.Spacing.xs)
                                        .fill(DesignSystem.Colors.backgroundSecondary)
                                )
                            }
                        }
                    }
                    
                    // Action Buttons
                    HStack(spacing: DesignSystem.Spacing.sm) {
                        Button("Clear All") {
                            onClearFilters()
                        }
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        
                        Spacer()
                        
                        Button("Apply Filters") {
                            onSearch()
                            isShowingFilters = false
                        }
                        .font(DesignSystem.Typography.caption1)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.primary)
                        .padding(.horizontal, DesignSystem.Spacing.md)
                        .padding(.vertical, DesignSystem.Spacing.xs)
                        .background(
                            Capsule()
                                .fill(DesignSystem.Colors.primary.opacity(0.1))
                        )
                    }
                }
                .padding(DesignSystem.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.Spacing.md)
                        .fill(DesignSystem.Colors.backgroundSecondary)
                )
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
    }
    
    // MARK: - Computed Properties
    
    private var hasActiveFilters: Bool {
        return !selectedCategories.isEmpty || 
               !selectedSources.isEmpty || 
               dateFrom != nil || 
               dateTo != nil
    }
    
    private var activeFilterCount: Int {
        var count = 0
        if !selectedCategories.isEmpty { count += 1 }
        if !selectedSources.isEmpty { count += 1 }
        if dateFrom != nil { count += 1 }
        if dateTo != nil { count += 1 }
        return count
    }
}

// MARK: - Category Filter Chip

struct CategoryFilterChip: View {
    let category: NewsCategory
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: DesignSystem.Spacing.xs) {
                Image(systemName: category.icon)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : categoryColor)
                
                Text(category.displayName)
                    .font(DesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary)
            }
            .padding(.horizontal, DesignSystem.Spacing.sm)
            .padding(.vertical, DesignSystem.Spacing.xs)
            .background(
                Capsule()
                    .fill(isSelected ? categoryColor : DesignSystem.Colors.backgroundSecondary)
            )
            .overlay(
                Capsule()
                    .stroke(categoryColor, lineWidth: isSelected ? 0 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
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

struct SearchAndFilterView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchAndFilterView(
                searchText: .constant(""),
                selectedCategories: .constant([]),
                selectedSources: .constant([]),
                sortOption: .constant(.publishedAt),
                sortOrder: .constant(.descending),
                dateFrom: .constant(nil),
                dateTo: .constant(nil),
                onSearch: {},
                onClearFilters: {}
            )
            
            Spacer()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
