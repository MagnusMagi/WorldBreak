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
    
    // Responsive sizing
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    private var isCompact: Bool {
        verticalSizeClass == .compact || horizontalSizeClass == .compact
    }
    
    private var horizontalPadding: CGFloat {
        isCompact ? 16 : 20
    }
    
    private var topPadding: CGFloat {
        isCompact ? 12 : 16
    }
    
    private var bottomPadding: CGFloat {
        isCompact ? 6 : 8
    }
    
    private var safeAreaPadding: CGFloat {
        isCompact ? 20 : 25
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    TabButton(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        isCompact: isCompact,
                        action: {
                            print("📱 \(tab.title) tab selected!")
                            onTabSelected(tab)
                        }
                    )
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
            
            // Safe area için ekstra alan
            Color.clear
                .frame(height: 0)
            
            // Ekstra padding için
            Rectangle()
                .fill(.regularMaterial)
                .frame(height: safeAreaPadding)
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
    let isCompact: Bool
    let action: () -> Void
    
    private var iconSize: CGFloat {
        isCompact ? 20 : 22
    }
    
    private var fontSize: CGFloat {
        isCompact ? 10 : 11
    }
    
    private var spacing: CGFloat {
        isCompact ? 4 : 6
    }
    
    private var verticalPadding: CGFloat {
        isCompact ? 6 : 8
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: spacing) {
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: iconSize, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .blue : .secondary)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
                
                Text(tab.title)
                    .font(.system(size: fontSize, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .blue : .secondary)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, verticalPadding)
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
        .previewDisplayName("Regular")
        
        VStack {
            Spacer()
            
            StandardBottomBar(
                selectedTab: .constant(.search),
                onTabSelected: { _ in }
            )
        }
        .background(Color(.systemGroupedBackground))
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .compact)
        .previewDisplayName("Compact")
    }
}
