//
//  PrivacyComponents.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// A row for privacy option selection
struct PrivacyOptionRow: View {
    let title: String
    let subtitle: String
    let currentValue: String
    let icon: String
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
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(currentValue)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
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

struct PrivacyComponents_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            PrivacyOptionRow(
                title: "Account Visibility",
                subtitle: "Control who can see your profile",
                currentValue: "Private",
                icon: "eye.fill",
                color: .blue
            ) {
                print("Visibility tapped")
            }
            
            PrivacyOptionRow(
                title: "Data Retention",
                subtitle: "How long to keep your data",
                currentValue: "6 Months",
                icon: "clock.fill",
                color: .orange
            ) {
                print("Retention tapped")
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
