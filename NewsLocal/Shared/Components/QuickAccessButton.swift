//
//  QuickAccessButton.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// A quick access button for profile shortcuts
struct QuickAccessButton: View {
    let icon: String
    let title: String
    let count: Int
    let color: Color
    let action: () -> Void
    
    init(
        icon: String,
        title: String,
        count: Int,
        color: Color = .blue,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.count = count
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(spacing: 2) {
                    Text("\(count)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

struct QuickAccessButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 12) {
            QuickAccessButton(
                icon: "clock.fill",
                title: "Recent",
                count: 5,
                color: .blue
            ) {
                print("Recent tapped")
            }
            
            QuickAccessButton(
                icon: "bookmark.fill",
                title: "Saved",
                count: 12,
                color: .green
            ) {
                print("Saved tapped")
            }
            
            QuickAccessButton(
                icon: "heart.fill",
                title: "Liked",
                count: 45,
                color: .red
            ) {
                print("Liked tapped")
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
