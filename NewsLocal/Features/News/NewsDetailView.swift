import SwiftUI

/// Detailed news article view
struct NewsDetailView: View {
    let article: NewsArticle
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                    // Article image
                    AsyncImage(url: article.imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
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
                        
                        // Engagement section
                        HStack {
                            // Like button
                            Button(action: {
                                // Handle like action
                            }) {
                                HStack(spacing: DesignSystem.Spacing.xs) {
                                    Image(systemName: "heart")
                                        .foregroundColor(DesignSystem.Colors.textSecondary)
                                    
                                    Text("\(article.likeCount)")
                                        .font(DesignSystem.Typography.body)
                                        .foregroundColor(DesignSystem.Colors.textSecondary)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            // Share button
                            Button(action: {
                                // Handle share action
                            }) {
                                HStack(spacing: DesignSystem.Spacing.xs) {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(DesignSystem.Colors.textSecondary)
                                    
                                    Text("\(article.shareCount)")
                                        .font(DesignSystem.Typography.body)
                                        .foregroundColor(DesignSystem.Colors.textSecondary)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            // Bookmark button
                            Button(action: {
                                // Handle bookmark action
                            }) {
                                Image(systemName: "bookmark")
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.top, DesignSystem.Spacing.md)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.md)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Handle share action
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}

// MARK: - Preview

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView(article: MockDataGenerator.generateMockArticles(count: 1).first!)
            .previewDisplayName("News Detail")
    }
}
