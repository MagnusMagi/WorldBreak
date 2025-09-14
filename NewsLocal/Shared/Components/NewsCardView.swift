import SwiftUI

/// Reusable news card component
struct NewsCardView: View {
    let article: NewsArticle
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Image
                AsyncImage(url: article.imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
                .frame(height: 200)
                .clipped()
                .cornerRadius(12, corners: [.topLeft, .topRight])
                
                VStack(alignment: .leading, spacing: 8) {
                    // Title
                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    // Summary
                    Text(article.summary)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Meta information
                    HStack {
                        // Source
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 8, height: 8)
                            
                            Text(article.source.name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Time ago
                        Text(article.timeAgo)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Read time
                    HStack {
                        Spacer()
                        
                        Text("\(article.readingTime) min read")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(16)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// MARK: - Corner Radius Extension

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview

struct NewsCardView_Previews: PreviewProvider {
    static var previews: some View {
        NewsCardView(
            article: MockDataGenerator.generateMockArticles(count: 1).first!,
            onTap: {}
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
