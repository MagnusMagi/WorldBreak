import SwiftUI

/// Enhanced detailed news article view with reading progress, bookmarks, and sharing
struct NewsDetailView: View {
    let article: NewsArticle
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ArticleDetailViewModel
    @State private var scrollOffset: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var viewportHeight: CGFloat = 0
    
    init(article: NewsArticle) {
        self.article = article
        self._viewModel = StateObject(wrappedValue: ArticleDetailViewModel(article: article))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                articleScrollView
                
                // Reading progress overlay
                VStack {
                    ReadingProgressView(
                        progress: viewModel.readingProgress,
                        timeRemaining: viewModel.estimatedTimeRemaining,
                        isVisible: viewModel.readingProgress > 0.1 && viewModel.readingProgress < 0.9
                    )
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Kapat") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .principal) {
                    CompactReadingProgressView(progress: viewModel.readingProgress)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.shareArticle()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .onAppear {
            viewportHeight = UIScreen.main.bounds.height
        }
        .sheet(isPresented: $viewModel.showingImageGallery) {
            ImageGalleryView(
                images: viewModel.articleImages,
                currentIndex: $viewModel.currentImageIndex,
                isPresented: $viewModel.showingImageGallery
            )
        }
        .sheet(isPresented: $viewModel.showingShareSheet) {
            ShareSheet(
                items: ArticleShareContent(article: viewModel.article).shareItems,
                excludedActivityTypes: [.assignToContact, .addToReadingList, .openInIBooks]
            )
        }
    }
    
    private var articleScrollView: some View {
        ScrollView {
            GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
            }
            .frame(height: 0)
            
            LazyVStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                // Article image
                AsyncImage(url: article.imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .onTapGesture {
                            if !viewModel.articleImages.isEmpty {
                                viewModel.showImageGallery(at: 0)
                            }
                        }
                } placeholder: {
                    Rectangle()
                        .fill(DesignSystem.Colors.backgroundSecondary)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                                .font(.largeTitle)
                        )
                }
                .frame(height: 250)
                .clipped()
                
                articleContent
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ContentHeightPreferenceKey.self, value: geometry.size.height)
                }
            )
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
            viewModel.updateReadingProgress(
                scrollOffset: abs(scrollOffset),
                contentHeight: contentHeight,
                viewportHeight: viewportHeight
            )
        }
        .onPreferenceChange(ContentHeightPreferenceKey.self) { value in
            contentHeight = value
        }
    }
    
    private var articleContent: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            // Breaking news badge
            if article.isBreaking {
                HStack {
                    Text("BREAKING")
                        .font(DesignSystem.Typography.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, DesignSystem.Spacing.sm)
                        .padding(.vertical, DesignSystem.Spacing.xs)
                        .background(DesignSystem.Colors.breakingNews)
                        .cornerRadius(DesignSystem.CornerRadius.xs)
                    
                    Spacer()
                }
            }
            
            // Article title
            Text(article.title)
                .font(DesignSystem.Typography.title1)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.leading)
            
            // Meta information
            HStack {
                // Source info
                HStack(spacing: DesignSystem.Spacing.xs) {
                    Circle()
                        .fill(DesignSystem.Colors.primary)
                        .frame(width: 8, height: 8)
                    
                    Text(article.source.name)
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
                
                Spacer()
                
                // Publication date
                Text(article.publishedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
            
            // Author
            HStack {
                Image(systemName: "person")
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                Text("By \(article.author)")
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                Spacer()
                
                // Read time
                Text("\(article.readingTime) min read")
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
            
            // Category and tags
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                CategoryChipView(
                    category: article.category,
                    isSelected: true,
                    onTap: {}
                )
                
                if !article.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            ForEach(article.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(DesignSystem.Typography.caption1)
                                    .foregroundColor(DesignSystem.Colors.primary)
                                    .padding(.horizontal, DesignSystem.Spacing.xs)
                                    .padding(.vertical, 2)
                                    .background(DesignSystem.Colors.primary.opacity(0.1))
                                    .cornerRadius(DesignSystem.CornerRadius.xs)
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.md)
                    }
                }
            }
            
            Divider()
                .background(DesignSystem.Colors.backgroundSecondary)
            
            // Article content
            Text(article.content)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
            
            // Enhanced engagement section
            HStack(spacing: 24) {
                // Like button
                Button(action: {
                    viewModel.toggleLike()
                }) {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isLiked ? .red : DesignSystem.Colors.textSecondary)
                            .font(.title3)
                        
                        Text("\(viewModel.likeCount)")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Share button
                Button(action: {
                    viewModel.shareArticle()
                }) {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .font(.title3)
                        
                        Text("\(viewModel.shareCount)")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                // Bookmark button
                Button(action: {
                    viewModel.toggleBookmark()
                }) {
                    Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(viewModel.isBookmarked ? .blue : DesignSystem.Colors.textSecondary)
                        .font(.title3)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.top, DesignSystem.Spacing.md)
            
            // Related articles section
            if !viewModel.relatedArticles.isEmpty {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    Text("İlgili Haberler")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    
                    ForEach(viewModel.relatedArticles.prefix(3)) { relatedArticle in
                        RelatedArticleRow(article: relatedArticle)
                    }
                }
                .padding(.top, DesignSystem.Spacing.lg)
            }
        }
    }
}

// MARK: - Supporting Views

/// Related article row for the detail view
struct RelatedArticleRow: View {
    let article: NewsArticle
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: article.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(DesignSystem.Colors.backgroundSecondary)
            }
            .frame(width: 80, height: 60)
            .clipped()
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .lineLimit(2)
                
                Text(article.timeAgo)
                    .font(DesignSystem.Typography.caption1)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preference Keys

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ContentHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Preview

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView(article: NewsArticle.mock)
            .previewDisplayName("Enhanced News Detail")
    }
}
