//
//  FilterSheet.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Sheet for configuring search filters
struct FilterSheet: View {
    @Binding var filters: SearchFilters
    let onApply: (SearchFilters) -> Void
    let onClear: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.lg) {
                    // Categories Section
                    FilterSection(
                        title: "Categories",
                        icon: "list.bullet"
                    ) {
                        CategoryFilterView(filters: $filters)
                    }
                    
                    // Sources Section
                    FilterSection(
                        title: "Sources",
                        icon: "building.2"
                    ) {
                        SourceFilterView(filters: $filters)
                    }
                    
                    // Date Range Section
                    FilterSection(
                        title: "Date Range",
                        icon: "calendar"
                    ) {
                        DateRangeFilterView(filters: $filters)
                    }
                    
                    // Sort Section
                    FilterSection(
                        title: "Sort By",
                        icon: "arrow.up.arrow.down"
                    ) {
                        SortFilterView(filters: $filters)
                    }
                }
                .padding(DesignSystem.Spacing.md)
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear All") {
                        onClear()
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.error)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        onApply(filters)
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Filter Section

struct FilterSection<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.primary)
                
                Text(title)
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
            }
            
            content
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.backgroundSecondary)
        .cornerRadius(DesignSystem.CornerRadius.md)
    }
}

// MARK: - Filter Views

struct CategoryFilterView: View {
    @Binding var filters: SearchFilters
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: DesignSystem.Spacing.sm) {
            ForEach(NewsCategory.allCases) { category in
                FilterToggleChip(
                    title: category.displayName,
                    isSelected: filters.categories?.contains { $0.id == category.id } ?? false
                ) {
                    toggleCategory(category)
                }
            }
        }
    }
    
    private func toggleCategory(_ category: NewsCategory) {
        var categories = filters.categories ?? []
        
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories.remove(at: index)
        } else {
            categories.append(category)
        }
        
        filters = SearchFilters(
            categories: categories.isEmpty ? nil : categories,
            sources: filters.sources,
            dateFrom: filters.dateFrom,
            dateTo: filters.dateTo,
            language: filters.language,
            country: filters.country,
            sortBy: filters.sortBy,
            sortOrder: filters.sortOrder
        )
    }
}

struct SourceFilterView: View {
    @Binding var filters: SearchFilters
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            ForEach(mockSources) { source in
                FilterToggleRow(
                    title: source.name,
                    subtitle: source.description,
                    isSelected: filters.sources?.contains { $0.id == source.id } ?? false
                ) {
                    toggleSource(source)
                }
            }
        }
    }
    
    private func toggleSource(_ source: NewsSource) {
        var sources = filters.sources ?? []
        
        if let index = sources.firstIndex(where: { $0.id == source.id }) {
            sources.remove(at: index)
        } else {
            sources.append(source)
        }
        
        filters = SearchFilters(
            categories: filters.categories,
            sources: sources.isEmpty ? nil : sources,
            dateFrom: filters.dateFrom,
            dateTo: filters.dateTo,
            language: filters.language,
            country: filters.country,
            sortBy: filters.sortBy,
            sortOrder: filters.sortOrder
        )
    }
}

struct DateRangeFilterView: View {
    @Binding var filters: SearchFilters
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            DatePicker(
                "From",
                selection: Binding(
                    get: { filters.dateFrom ?? Date() },
                    set: { filters = SearchFilters(
                        categories: filters.categories,
                        sources: filters.sources,
                        dateFrom: $0,
                        dateTo: filters.dateTo,
                        language: filters.language,
                        country: filters.country,
                        sortBy: filters.sortBy,
                        sortOrder: filters.sortOrder
                    )}
                ),
                displayedComponents: .date
            )
            .datePickerStyle(CompactDatePickerStyle())
            
            DatePicker(
                "To",
                selection: Binding(
                    get: { filters.dateTo ?? Date() },
                    set: { filters = SearchFilters(
                        categories: filters.categories,
                        sources: filters.sources,
                        dateFrom: filters.dateFrom,
                        dateTo: $0,
                        language: filters.language,
                        country: filters.country,
                        sortBy: filters.sortBy,
                        sortOrder: filters.sortOrder
                    )}
                ),
                displayedComponents: .date
            )
            .datePickerStyle(CompactDatePickerStyle())
        }
    }
}

struct SortFilterView: View {
    @Binding var filters: SearchFilters
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            ForEach(SearchFilters.SortOption.allCases) { option in
                FilterToggleRow(
                    title: option.displayName,
                    isSelected: filters.sortBy == option
                ) {
                    filters = SearchFilters(
                        categories: filters.categories,
                        sources: filters.sources,
                        dateFrom: filters.dateFrom,
                        dateTo: filters.dateTo,
                        language: filters.language,
                        country: filters.country,
                        sortBy: option,
                        sortOrder: filters.sortOrder
                    )
                }
            }
        }
    }
}

// MARK: - Filter Components

struct FilterToggleChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DesignSystem.Typography.caption1)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary)
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.full)
                        .fill(isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.backgroundSecondary)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FilterToggleRow: View {
    let title: String
    let subtitle: String?
    let isSelected: Bool
    let action: () -> Void
    
    init(title: String, subtitle: String? = nil, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.md) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(title)
                        .font(DesignSystem.Typography.body)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.textTertiary)
            }
            .padding(DesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                    .fill(isSelected ? DesignSystem.Colors.primary.opacity(0.1) : DesignSystem.Colors.background)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Mock Data

private let mockSources = [
    NewsSource(name: "BBC News", description: "British Broadcasting Corporation"),
    NewsSource(name: "CNN", description: "Cable News Network"),
    NewsSource(name: "Reuters", description: "International news agency"),
    NewsSource(name: "Associated Press", description: "American news agency")
]

// MARK: - Preview

struct FilterSheet_Previews: PreviewProvider {
    static var previews: some View {
        FilterSheet(
            filters: .constant(SearchFilters()),
            onApply: { _ in },
            onClear: { }
        )
    }
}
