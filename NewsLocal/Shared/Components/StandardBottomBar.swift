//
//  StandardBottomBar.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

// MARK: - Standard Bottom Bar Component

/// Standardized bottom bar component for all pages
struct StandardBottomBar: View {
    @Binding var selectedTab: TabItem
    let onTabSelected: (TabItem) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                            TabButton(
                                tab: tab,
                                isSelected: selectedTab == tab,
                                action: {
                                    print("📱 \(tab.title) tab selected!")
                                    onTabSelected(tab)
                                }
                            )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            // Safe area için ekstra alan
            Color.clear
                .frame(height: 0)
            
            // Ekstra padding için
            Rectangle()
                .fill(.regularMaterial)
                .frame(height: 25)
                .ignoresSafeArea(.all, edges: .bottom)
        }
        .background(
            Rectangle()
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: -2)
                .ignoresSafeArea(.all, edges: .bottom)
        )
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

// MARK: - Tab Button Component

struct TabButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 22, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .blue : .secondary)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
                
                Text(tab.title)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .blue : .secondary)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Tab Item Enum moved to ContentView.swift

// MARK: - Preview

struct StandardBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            
            StandardBottomBar(
                selectedTab: .constant(.home),
                onTabSelected: { _ in }
            )
        }
        .background(Color(.systemGroupedBackground))
    }
}
