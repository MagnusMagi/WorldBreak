//
//  InfiniteScrollView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI
import Combine

/// Infinite scroll component with loading indicators
struct InfiniteScrollView<Content: View>: View {
    let content: Content
    let isLoading: Bool
    let hasMore: Bool
    let onLoadMore: () -> Void
    
    init(
        isLoading: Bool = false,
        hasMore: Bool = true,
        onLoadMore: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.isLoading = isLoading
        self.hasMore = hasMore
        self.onLoadMore = onLoadMore
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
            
            // Loading indicator at bottom
            if isLoading {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: DesignSystem.Colors.primary))
                    
                    Text("Loading more articles...")
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
                .padding(.vertical, DesignSystem.Spacing.lg)
                .frame(maxWidth: .infinity)
            } else if !hasMore {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.success)
                    
                    Text("You've reached the end")
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
                .padding(.vertical, DesignSystem.Spacing.lg)
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            if hasMore && !isLoading {
                onLoadMore()
            }
        }
    }
}

// MARK: - Pagination Helper

class PaginationManager: ObservableObject {
    @Published var currentPage = 1
    @Published var isLoading = false
    @Published var hasMore = true
    @Published var articles: [NewsArticle] = []
    
    private let pageSize = 20
    private var newsService: NewsServiceProtocol
    
    init(newsService: NewsServiceProtocol = ServiceFactory.createNewsService(isMock: true)) {
        self.newsService = newsService
    }
    
    func loadMoreArticles() {
        guard !isLoading && hasMore else { return }
        
        isLoading = true
        
        newsService.fetchTopHeadlines(category: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure = completion {
                    // Handle error
                }
            } receiveValue: { [weak self] newArticles in
                self?.articles.append(contentsOf: newArticles)
                self?.currentPage += 1
                self?.hasMore = newArticles.count == self?.pageSize
            }
            .store(in: &cancellables)
    }
    
    func refreshArticles() {
        currentPage = 1
        hasMore = true
        articles.removeAll()
        loadMoreArticles()
    }
    
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - Loading States

struct LoadingStateView: View {
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            // Loading animation
            VStack(spacing: DesignSystem.Spacing.md) {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: DesignSystem.Colors.primary))
                
                Text(message)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Action button
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(DesignSystem.Typography.body)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.primary)
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.vertical, DesignSystem.Spacing.sm)
                        .background(
                            Capsule()
                                .fill(DesignSystem.Colors.primary.opacity(0.1))
                        )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.Spacing.xl)
    }
}


// MARK: - Preview

struct InfiniteScrollView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InfiniteScrollView(
                isLoading: false,
                hasMore: true,
                onLoadMore: {}
            ) {
                VStack {
                    ForEach(0..<5) { index in
                        ArticleCardSkeleton()
                            .padding(.horizontal, DesignSystem.Spacing.md)
                    }
                }
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
