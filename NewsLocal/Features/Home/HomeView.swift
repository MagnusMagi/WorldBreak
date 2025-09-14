import SwiftUI
import Combine

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State private var selectedCategory: NewsCategory? = nil
    @Binding var selectedTab: TabItem
    
    // Mock data for trending topics and breaking news
    @State private var trendingTopics: [TrendingTopic] = []
    @State private var breakingNews: [NewsArticle] = []
    @State private var categoryArticles: [NewsCategory: [NewsArticle]] = [:]
    
    var body: some View {
        NavigationView {
            StandardPageWrapper(
                title: "Home",
                showCategories: true,
                selectedCategory: selectedCategory,
                selectedTab: .home,
                onCategorySelected: { category in
                    selectedCategory = category
                    if let category = category {
                        viewModel.fetchNewsByCategory(category)
                    } else {
                        viewModel.fetchTopHeadlines()
                    }
                },
                onTabSelected: { tab in
                    selectedTab = tab
                }
            ) {
                ScrollView {
                    LazyVStack(spacing: DesignSystem.Spacing.lg) {
                        // Breaking News Banner
                        if !breakingNews.isEmpty {
                            BreakingNewsBanner(
                                articles: breakingNews,
                                onTap: { article in
                                    // TODO: Navigate to article detail
                                }
                            )
                        }
                        
                        // Hero Article
                        if let heroArticle = viewModel.articles.first {
                            HeroArticleCard(article: heroArticle) {
                                // TODO: Navigate to article detail
                            }
                            .padding(.horizontal, DesignSystem.Spacing.md)
                        }
                        
                        // Trending Topics
                        if !trendingTopics.isEmpty {
                            TrendingTopicsView(
                                trendingTopics: trendingTopics,
                                onTopicSelected: { topic in
                                    // TODO: Filter articles by trending topic
                                }
                            )
                        }
                        
                        // Category Sections
                        ForEach(NewsCategory.allCases.prefix(4), id: \.id) { category in
                            if let articles = categoryArticles[category], !articles.isEmpty {
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                                    CategorySectionHeader(
                                        category: category,
                                        articleCount: articles.count,
                                        onSeeAll: {
                                            selectedCategory = category
                                            viewModel.fetchNewsByCategory(category)
                                        }
                                    )
                                    
                                    CategoryArticleGrid(
                                        articles: Array(articles.prefix(5)),
                                        onArticleTap: { article in
                                            // TODO: Navigate to article detail
                                        },
                                        onLike: { article in
                                            // TODO: Handle like action
                                        },
                                        onShare: { article in
                                            // TODO: Handle share action
                                        },
                                        onBookmark: { article in
                                            // TODO: Handle bookmark action
                                        }
                                    )
                                }
                            }
                        }
                        
                        // Standard Article Feed
                        if selectedCategory == nil {
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                                HStack {
                                    Image(systemName: "newspaper")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(DesignSystem.Colors.primary)
                                    
                                    Text("Latest News")
                                        .font(DesignSystem.Typography.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(DesignSystem.Colors.textPrimary)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, DesignSystem.Spacing.md)
                                
                                LazyVStack(spacing: DesignSystem.Spacing.sm) {
                                    ForEach(viewModel.articles.dropFirst()) { article in
                                        StandardArticleCard(
                                            article: article,
                                            onTap: {
                                                // TODO: Navigate to article detail
                                            },
                                            onLike: {
                                                // TODO: Handle like action
                                            },
                                            onShare: {
                                                // TODO: Handle share action
                                            },
                                            onBookmark: {
                                                // TODO: Handle bookmark action
                                            }
                                        )
                                        .padding(.horizontal, DesignSystem.Spacing.md)
                                    }
                                }
                            }
                        }
                        
                        // Loading State
                        if viewModel.isLoading {
                            VStack(spacing: DesignSystem.Spacing.md) {
                                ProgressView()
                                    .scaleEffect(1.2)
                                
                                Text("Loading News...")
                                    .font(DesignSystem.Typography.body)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, DesignSystem.Spacing.xl)
                        }
                        
                        // Error State
                        if let error = viewModel.error {
                            VStack(spacing: DesignSystem.Spacing.md) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.system(size: 48, weight: .light))
                                    .foregroundColor(DesignSystem.Colors.error)
                                
                                Text("Error Loading News")
                                    .font(DesignSystem.Typography.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                
                                Text(error.localizedDescription)
                                    .font(DesignSystem.Typography.body)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                                    .multilineTextAlignment(.center)
                                
                                Button("Try Again") {
                                    viewModel.fetchTopHeadlines()
                                }
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
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, DesignSystem.Spacing.xl)
                        }
                    }
                    .padding(.bottom, 100) // Bottom bar space
                }
            }
            .onAppear {
                loadHomepageData()
            }
            .refreshable {
                await refreshHomepageData()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadHomepageData() {
        viewModel.fetchTopHeadlines()
        loadMockData()
    }
    
    private func refreshHomepageData() async {
        viewModel.fetchTopHeadlines()
        loadMockData()
    }
    
    private func loadMockData() {
        // Load trending topics
        trendingTopics = [
            TrendingTopic(
                topic: "Artificial Intelligence",
                category: .technology,
                popularity: 95.5,
                growth: 12.3,
                articleCount: 42
            ),
            TrendingTopic(
                topic: "Climate Change",
                category: .world,
                popularity: 88.2,
                growth: 8.7,
                articleCount: 28
            ),
            TrendingTopic(
                topic: "Stock Market",
                category: .business,
                popularity: 76.8,
                growth: -3.2,
                articleCount: 35
            ),
            TrendingTopic(
                topic: "Olympics 2024",
                category: .sports,
                popularity: 92.1,
                growth: 15.6,
                articleCount: 67
            ),
            TrendingTopic(
                topic: "Healthcare Reform",
                category: .health,
                popularity: 71.3,
                growth: 5.4,
                articleCount: 23
            )
        ]
        
        // Load breaking news
        breakingNews = [
            NewsArticle(
                id: "breaking-1",
                title: "Breaking: Major Economic Policy Changes Announced",
                content: "Breaking news content...",
                summary: "Major economic policy changes announced by government officials.",
                author: "Breaking News Team",
                source: NewsSource(name: "Breaking News Network"),
                publishedAt: Date(),
                category: .politics,
                imageUrl: URL(string: "https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?w=800"),
                articleUrl: URL(string: "https://example.com")!,
                isBreaking: true
            )
        ]
        
        // Load category articles
        categoryArticles = [
            .technology: NewsArticle.mockArray,
            .business: NewsArticle.mockArray,
            .sports: NewsArticle.mockArray,
            .health: NewsArticle.mockArray
        ]
    }
}

// MARK: - Legacy NewsArticleRow (kept for compatibility)

struct NewsArticleRow: View {
    let article: NewsArticle
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title)
                .font(.headline)
            Text(article.summary)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(.home))
    }
}