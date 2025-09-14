import SwiftUI
import Combine

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State private var selectedCategory: NewsCategory? = nil
    @Binding var selectedTab: TabItem
    
    // Mock data for breaking news
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
                        
                        // Minimalist Hero Article
                        if let heroArticle = viewModel.articles.first {
                            VStack(spacing: 0) {
                                MinimalistSectionHeader(title: "Featured") {
                                    // TODO: Navigate to featured articles
                                }
                                
                                Divider()
                                    .background(DesignSystem.Colors.border)
                                
                                MinimalistArticleCard(
                                    article: heroArticle,
                                    onTap: {
                                        // TODO: Navigate to article detail
                                    }
                                )
                            }
                            .background(Color(.systemBackground))
                            .cornerRadius(DesignSystem.Spacing.sm)
                            .shadow(color: DesignSystem.Colors.shadow, radius: 1, x: 0, y: 1)
                            .padding(.horizontal, DesignSystem.Spacing.md)
                        }
                        
                        
                        // Standardized Category Sections
                        ForEach(NewsCategory.allCases.prefix(3), id: \.id) { category in
                            if let articles = categoryArticles[category], !articles.isEmpty {
                                // Convert NewsCategory to CategoryStandards.MainCategory
                                let standardizedCategory = convertToStandardizedCategory(category)
                                
                                StandardizedCategoryView(
                                    category: standardizedCategory,
                                    articles: Array(articles.prefix(5)),
                                    onArticleTap: { article in
                                        // TODO: Navigate to article detail
                                    },
                                    onSeeAll: {
                                        selectedCategory = category
                                        viewModel.fetchNewsByCategory(category)
                                    }
                                )
                                .padding(.horizontal, DesignSystem.Spacing.md)
                            }
                        }
                        
                        // Minimalist Latest News Section
                        if selectedCategory == nil {
                            VStack(spacing: 0) {
                                // Minimalist section header
                                MinimalistSectionHeader(title: "Latest News") {
                                    // TODO: Navigate to all news
                                }
                                
                                Divider()
                                    .background(DesignSystem.Colors.border)
                                
                                // Minimalist article list
                                LazyVStack(spacing: 0) {
                                    ForEach(viewModel.articles.dropFirst()) { article in
                                        MinimalistArticleCard(
                                            article: article,
                                            onTap: {
                                                // TODO: Navigate to article detail
                                            }
                                        )
                                        
                                        if article.id != viewModel.articles.dropFirst().last?.id {
                                            Divider()
                                                .background(DesignSystem.Colors.border)
                                                .padding(.horizontal, DesignSystem.Spacing.lg)
                                        }
                                    }
                                }
                            }
                            .background(Color(.systemBackground))
                            .cornerRadius(DesignSystem.Spacing.sm)
                            .shadow(color: DesignSystem.Colors.shadow, radius: 1, x: 0, y: 1)
                            .padding(.horizontal, DesignSystem.Spacing.md)
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
    
    private func convertToStandardizedCategory(_ category: NewsCategory) -> CategoryStandards.MainCategory {
        switch category.id {
        case "general": return .general
        case "technology": return .technology
        case "business": return .business
        case "science": return .science
        case "health": return .health
        case "sports": return .sports
        case "entertainment": return .entertainment
        case "politics": return .politics
        case "world": return .world
        case "local": return .local
        default: return .general
        }
    }
    
    private func loadMockData() {
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