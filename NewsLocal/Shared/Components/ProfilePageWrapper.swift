//
//  ProfilePageWrapper.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

// MARK: - Profile Page Wrapper

/// Specialized page wrapper for ProfileView with custom header
struct ProfilePageWrapper<Content: View>: View {
    let title: String
    let selectedTab: TabItem
    let onTabSelected: (TabItem) -> Void
    let content: () -> Content
    
    init(
        title: String,
        selectedTab: TabItem,
        onTabSelected: @escaping (TabItem) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.selectedTab = selectedTab
        self.onTabSelected = onTabSelected
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content area
            VStack(spacing: 0) {
                // Profile Header
                ProfilePageHeader(title: title)
                
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
        .background(DesignSystem.Colors.background)
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

// MARK: - Profile Page Header

/// Simple header for ProfileView without categories
struct ProfilePageHeader: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(DesignSystem.Typography.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.md)
            
            Divider()
                .background(DesignSystem.Colors.textTertiary)
        }
        .background(DesignSystem.Colors.background)
    }
}

// MARK: - Preview

struct ProfilePageWrapper_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageWrapper(
            title: "Profile",
            selectedTab: .profile,
            onTabSelected: { _ in }
        ) {
            VStack {
                Text("Profile Content")
                    .font(DesignSystem.Typography.title2)
                
                Spacer()
            }
            .padding()
        }
    }
}
