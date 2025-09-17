//
//  NewsFeedView.swift
//  WorldBreak
//
//  Created by Magnus Magi on 16.09.2025.
//

import SwiftUI

struct NewsFeedView: View {
    @EnvironmentObject var userPreferences: UserPreferences
    @State private var selectedCategoryIndex = 0
    @State private var articles: [NewsArticle] = NewsArticle.mockArticles
    @State private var isRefreshing = false
    
    private var selectedCategories: [Category] {
        userPreferences.selectedCategories.isEmpty ? Category.allCategories : userPreferences.selectedCategories
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Category Tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(selectedCategories.enumerated()), id: \.element.id) { index, category in
                        CategoryTab(
                            category: category,
                            isSelected: selectedCategoryIndex == index
                        ) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedCategoryIndex = index
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 16)
            .background(AppColors.background)
            
            // News Articles
            TabView(selection: $selectedCategoryIndex) {
                ForEach(Array(selectedCategories.enumerated()), id: \.element.id) { index, category in
                    NewsList(
                        articles: filteredArticles(for: category),
                        isRefreshing: $isRefreshing
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
    
    private func filteredArticles(for category: Category) -> [NewsArticle] {
        articles.filter { $0.category.id == category.id }
    }
}


struct NewsList: View {
    let articles: [NewsArticle]
    @Binding var isRefreshing: Bool
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                    ForEach(articles) { article in
                        NewsArticleCard(article: article)
                    }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .refreshable {
            await refreshNews()
        }
    }
    
    private func refreshNews() async {
        isRefreshing = true
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isRefreshing = false
    }
}


#Preview {
    NewsFeedView()
}
