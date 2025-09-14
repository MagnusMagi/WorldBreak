//
//  SimpleSearchBarView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Simple search bar component with basic functionality
struct SimpleSearchBarView: View {
    @Binding var searchText: String
    let onClear: (() -> Void)?
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            TextField("Search news...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .accessibilityLabel("Search text field")
                .accessibilityHint("Enter search terms for news articles")
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    onClear?()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
        .padding(.vertical, DesignSystem.Spacing.sm)
        .background(DesignSystem.Colors.backgroundSecondary)
        .cornerRadius(DesignSystem.CornerRadius.full)
    }
}

// MARK: - Preview

struct SimpleSearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            SimpleSearchBarView(
                searchText: .constant(""),
                onClear: nil
            )
            
            SimpleSearchBarView(
                searchText: .constant("Technology"),
                onClear: nil
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
