import SwiftUI

/// Breaking news banner component
struct BreakingNewsBanner: View {
    let articles: [NewsArticle]
    let onTap: (NewsArticle) -> Void
    
    @State private var currentIndex = 0
    @State private var timer: Timer?
    
    var body: some View {
        if !articles.isEmpty {
            VStack(spacing: 0) {
                // Breaking news header
                HStack {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.white)
                            .font(.caption)
                        
                        Text("BREAKING")
                            .font(DesignSystem.Typography.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.sm)
                    .padding(.vertical, DesignSystem.Spacing.xs)
                    .background(DesignSystem.Colors.breakingNews)
                    .cornerRadius(DesignSystem.CornerRadius.xs)
                    
                    Spacer()
                    
                    // Auto-scroll indicator
                    if articles.count > 1 {
                        HStack(spacing: 4) {
                            ForEach(0..<min(articles.count, 5), id: \.self) { index in
                                Circle()
                                    .fill(currentIndex == index ? Color.white : Color.white.opacity(0.5))
                                    .frame(width: 4, height: 4)
                            }
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.sm)
                .background(DesignSystem.Colors.breakingNews.opacity(0.1))
                
                // Breaking news content
                TabView(selection: $currentIndex) {
                    ForEach(Array(articles.enumerated()), id: \.element.id) { index, article in
                        BreakingNewsItem(article: article) {
                            onTap(article)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 60)
                .onAppear {
                    startAutoScroll()
                }
                .onDisappear {
                    stopAutoScroll()
                }
            }
            .cardStyle()
            .padding(.horizontal, DesignSystem.Spacing.md)
        }
    }
    
    private func startAutoScroll() {
        guard articles.count > 1 else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
            withAnimation(DesignSystem.Animation.standard) {
                currentIndex = (currentIndex + 1) % articles.count
            }
        }
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Breaking News Item

struct BreakingNewsItem: View {
    let article: NewsArticle
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(DesignSystem.Typography.body)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text(article.source.name)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                        
                        Spacer()
                        
                        Text(article.timeAgo)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

struct BreakingNewsBanner_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BreakingNewsBanner(
                articles: MockDataGenerator.generateMockArticles(count: 3).map { article in
                    NewsArticle(
                        id: article.id,
                        title: article.title,
                        content: article.content,
                        summary: article.summary,
                        author: article.author,
                        source: article.source,
                        publishedAt: article.publishedAt,
                        category: article.category,
                        imageUrl: article.imageUrl,
                        articleUrl: article.articleUrl,
                        isBreaking: true
                    )
                },
                onTap: { _ in }
            )
            
            Spacer()
        }
        .background(DesignSystem.Colors.background)
        .previewLayout(.sizeThatFits)
    }
}
