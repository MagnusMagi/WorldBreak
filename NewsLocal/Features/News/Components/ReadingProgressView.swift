//
//  ReadingProgressView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Reading progress indicator for article detail view
struct ReadingProgressView: View {
    let progress: Double
    let timeRemaining: String
    let isVisible: Bool
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        if isVisible {
            VStack(spacing: 8) {
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 4)
                        
                        // Progress fill
                        RoundedRectangle(cornerRadius: 2)
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue, Color.purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * animatedProgress, height: 4)
                            .animation(.easeInOut(duration: 0.3), value: animatedProgress)
                    }
                }
                .frame(height: 4)
                
                // Time remaining
                HStack {
                    Image(systemName: "clock")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(timeRemaining)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Color(.systemBackground)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5)) {
                    animatedProgress = progress
                }
            }
            .onChange(of: progress) { newProgress in
                withAnimation(.easeInOut(duration: 0.3)) {
                    animatedProgress = newProgress
                }
            }
        }
    }
}

/// Compact reading progress for toolbar
struct CompactReadingProgressView: View {
    let progress: Double
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "book.fill")
                .font(.caption)
                .foregroundColor(.blue)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 2)
                    
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * progress, height: 2)
                        .animation(.easeInOut(duration: 0.2), value: progress)
                }
            }
            .frame(width: 40, height: 2)
            
            Text("\(Int(progress * 100))%")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Color(.systemBackground)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        )
    }
}

// MARK: - Preview

struct ReadingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ReadingProgressView(
                progress: 0.3,
                timeRemaining: "5 dk kaldı",
                isVisible: true
            )
            
            ReadingProgressView(
                progress: 0.75,
                timeRemaining: "2 dk kaldı",
                isVisible: true
            )
            
            CompactReadingProgressView(progress: 0.45)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
