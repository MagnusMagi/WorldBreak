//
//  CategorySelectionView.swift
//  WorldBreak
//
//  Created by Magnus Magi on 16.09.2025.
//

import SwiftUI

struct CategorySelectionView: View {
    @EnvironmentObject var userPreferences: UserPreferences
    @State private var selectedCategories: [Category] = []
    @State private var showThemeSelection = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
                VStack(spacing: 12) {
                    Text("Kategorilerinizi Seçin")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Text("En az 3 kategori seçin")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                
                // Categories Grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Category.allCategories) { category in
                            CategoryCard(
                                category: category,
                                isSelected: selectedCategories.contains(category)
                            ) {
                                toggleCategory(category)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Continue Button
                VStack(spacing: 12) {
                            if !selectedCategories.isEmpty {
                                Text("\(selectedCategories.count) kategori seçildi")
                                    .font(.caption)
                            }
                    
                    Button(action: {
                        userPreferences.selectedCategories = selectedCategories
                        showThemeSelection = true
                    }) {
                        HStack {
                            Text("Devam Et")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.primary)
                        .cornerRadius(12)
                    }
                    .disabled(!hasMinimumSelection)
                    .opacity(hasMinimumSelection ? 1.0 : 0.6)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showThemeSelection) {
            ThemeSelectionView()
        }
    }
    
    private var hasMinimumSelection: Bool {
        selectedCategories.count >= 3
    }
    
    private func toggleCategory(_ category: Category) {
        if let index = selectedCategories.firstIndex(of: category) {
            selectedCategories.remove(at: index)
        } else {
            selectedCategories.append(category)
        }
    }
}


#Preview {
    CategorySelectionView()
}
