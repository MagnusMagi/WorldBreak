//
//  ThemeSelectionView.swift
//  WorldBreak
//
//  Created by Magnus Magi on 16.09.2025.
//

import SwiftUI

struct ThemeSelectionView: View {
    @EnvironmentObject var userPreferences: UserPreferences
    @State private var selectedTheme: Theme = Theme.allThemes[0]
    @State private var showNewsFeed = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [AppColors.background, AppColors.groupedBackground]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "paintpalette.fill")
                        .font(.system(size: 60))
                        .foregroundColor(AppColors.primary)
                    
                    
                    Text("İstediğiniz zaman değiştirebilirsiniz")
                        .font(.body)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                
                // Theme Options
                VStack(spacing: 16) {
                    ForEach(Theme.allThemes) { theme in
                        ThemeCard(
                            theme: theme,
                            isSelected: selectedTheme.id == theme.id
                        ) {
                            selectedTheme = theme
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Continue Button
                Button(action: {
                    userPreferences.selectedTheme = selectedTheme
                    userPreferences.completePersonalization()
                    showNewsFeed = true
                }) {
                    HStack {
                        Text("Haberleri Görüntüle")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [AppColors.primary, AppColors.primary.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showNewsFeed) {
            NewsFeedView()
        }
    }
}


#Preview {
    ThemeSelectionView()
}
