//
//  StandardPageWrapper.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

// MARK: - Standard Page Wrapper

/// Standardized page wrapper for all pages (except Profile)
struct StandardPageWrapper<Content: View>: View {
    let title: String
    let showCategories: Bool
    let selectedCategory: NewsCategory?
    let selectedTab: TabItem
    let onCategorySelected: ((NewsCategory?) -> Void)?
    let onTabSelected: (TabItem) -> Void
    let content: () -> Content
    
    init(
        title: String,
        showCategories: Bool = false,
        selectedCategory: NewsCategory? = nil,
        selectedTab: TabItem,
        onCategorySelected: ((NewsCategory?) -> Void)? = nil,
        onTabSelected: @escaping (TabItem) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.showCategories = showCategories
        self.selectedCategory = selectedCategory
        self.selectedTab = selectedTab
        self.onCategorySelected = onCategorySelected
        self.onTabSelected = onTabSelected
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content area
            VStack(spacing: 0) {
                // Standard Header
                StandardHeader(
                    title: title,
                    showCategories: showCategories,
                    selectedCategory: selectedCategory,
                    onCategorySelected: onCategorySelected
                )
                
                // Main Content
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Sticky Bottom Bar
            StandardBottomBar(
                selectedTab: .constant(selectedTab),
                onTabSelected: onTabSelected
            )
        }
        .navigationBarHidden(true)
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

// MARK: - Preview

struct StandardPageWrapper_Previews: PreviewProvider {
    static var previews: some View {
        StandardPageWrapper(
            title: "Home",
            showCategories: true,
            selectedCategory: nil,
            selectedTab: .home,
            onCategorySelected: { _ in },
            onTabSelected: { _ in }
        ) {
            VStack {
                Text("Main Content")
                    .font(.title2)
                
                Spacer()
            }
            .padding()
        }
    }
}
