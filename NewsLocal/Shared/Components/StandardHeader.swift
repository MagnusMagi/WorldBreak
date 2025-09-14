//
//  StandardHeader.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

// MARK: - Standard Header Component

/// Standardized header component for all pages (except Profile)
struct StandardHeader: View {
    let title: String
    let showCategories: Bool
    let selectedCategory: NewsCategory?
    let onCategorySelected: ((NewsCategory?) -> Void)?
    
    init(
        title: String,
        showCategories: Bool = false,
        selectedCategory: NewsCategory? = nil,
        onCategorySelected: ((NewsCategory?) -> Void)? = nil
    ) {
        self.title = title
        self.showCategories = showCategories
        self.selectedCategory = selectedCategory
        self.onCategorySelected = onCategorySelected
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Page Title
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Optional action buttons (can be customized per page)
                if title == "Home" {
                    HStack(spacing: 16) {
                        NavigationLink(destination: AIChatbotView()) {
                            Image(systemName: "sparkle")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            print("🔔 Notifications button tapped!")
                        }) {
                            Image(systemName: "bell")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // Category chips (only for Home page)
            if showCategories {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        // Tümü seçeneği
                        CategoryChip(
                            title: "Tümü",
                            isSelected: selectedCategory == nil,
                            action: {
                                print("📂 Tümü category selected!")
                                onCategorySelected?(nil)
                            }
                        )
                        
                        // Kategori seçenekleri
                        ForEach(NewsCategory.allCases, id: \.id) { category in
                            CategoryChip(
                                title: category.displayName,
                                isSelected: selectedCategory?.id == category.id,
                                action: {
                                    print("🏷️ \(category.displayName) category selected!")
                                    onCategorySelected?(category)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .background(Color(.systemBackground))
            }
            
            Divider()
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Category Chip Component

/// Small category chip component
struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.blue : Color(.systemGray6))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

struct StandardHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StandardHeader(
                title: "Home",
                showCategories: true,
                selectedCategory: nil,
                onCategorySelected: { _ in }
            )
            
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
    }
}
