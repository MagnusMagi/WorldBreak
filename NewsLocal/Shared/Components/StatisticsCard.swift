//
//  StatisticsCard.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// A card component for displaying user statistics
struct StatisticsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let subtitle: String?
    
    init(
        title: String,
        value: String,
        icon: String,
        color: Color = .blue,
        subtitle: String? = nil
    ) {
        self.title = title
        self.value = value
        self.icon = icon
        self.color = color
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            // Value
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Title
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            // Subtitle (optional)
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

// MARK: - Preview

struct StatisticsCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                StatisticsCard(
                    title: "Articles Read",
                    value: "150",
                    icon: "book.fill",
                    color: .blue
                )
                
                StatisticsCard(
                    title: "Liked",
                    value: "45",
                    icon: "heart.fill",
                    color: .red
                )
            }
            
            HStack(spacing: 12) {
                StatisticsCard(
                    title: "Saved",
                    value: "12",
                    icon: "bookmark.fill",
                    color: .green
                )
                
                StatisticsCard(
                    title: "Streak",
                    value: "7 days",
                    icon: "flame.fill",
                    color: .orange,
                    subtitle: "Keep it up!"
                )
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
