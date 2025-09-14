//
//  ThemeComponents.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// A row for theme selection options
struct ThemeOptionRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: "circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// A preview card showing how content will look
struct PreviewCard: View {
    let title: String
    let subtitle: String
    let theme: AppTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
        .preferredColorScheme(theme == .light ? .light : theme == .dark ? .dark : nil)
    }
}

// MARK: - Preview

struct ThemeComponents_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            ThemeOptionRow(
                title: "Light",
                subtitle: "Always use light appearance",
                icon: "sun.max.fill",
                isSelected: true,
                color: .orange
            ) {
                print("Light selected")
            }
            
            ThemeOptionRow(
                title: "Dark",
                subtitle: "Always use dark appearance",
                icon: "moon.fill",
                isSelected: false,
                color: .blue
            ) {
                print("Dark selected")
            }
            
            PreviewCard(
                title: "Sample Article Title",
                subtitle: "This is how your articles will look with current settings",
                theme: .light
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
