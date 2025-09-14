import Foundation

/// Mock data generator for development and testing
class MockDataGenerator {
    
    private static let sampleTitles = [
        "Breaking: Major Economic Policy Changes Announced",
        "Technology Giant Reports Record Quarterly Earnings",
        "Climate Summit Reaches Historic Agreement"
    ]
    
    private static let sampleContent = [
        "In a significant development that will impact millions of citizens, government officials today announced comprehensive economic reforms.",
        "The technology sector continues to show remarkable resilience as leading companies report unprecedented growth.",
        "After weeks of intensive negotiations, world leaders have reached a groundbreaking agreement on climate action."
    ]
    
    private static let sampleAuthors = [
        "Sarah Johnson", "Michael Chen", "Emily Rodriguez", "David Thompson"
    ]
    
    private static let sampleSources = [
        "TechNews Daily", "Global Times", "Business Weekly", "Science Today"
    ]
    
    static func generateMockArticles(count: Int = 50) -> [NewsArticle] {
        var articles: [NewsArticle] = []
        
        for i in 0..<count {
            let article = generateMockArticle(id: "article_\(i)")
            articles.append(article)
        }
        
        return articles
    }
    
    private static func generateMockArticle(id: String) -> NewsArticle {
        let titleIndex = Int.random(in: 0..<sampleTitles.count)
        let contentIndex = Int.random(in: 0..<sampleContent.count)
        let authorIndex = Int.random(in: 0..<sampleAuthors.count)
        let sourceIndex = Int.random(in: 0..<sampleSources.count)
        let categoryIndex = Int.random(in: 0..<NewsCategory.allCases.count)
        
        let category = NewsCategory.allCases[categoryIndex]
        let publishedDate = generateRandomDate()
        
        let sourceName = sampleSources[sourceIndex]
        let newsSource = NewsSource(
            id: "source_\(sourceIndex)",
            name: sourceName,
            description: "A mock news source for \(sourceName)",
            url: URL(string: "https://example.com/source/\(sourceName.replacingOccurrences(of: " ", with: "-").lowercased())")!,
            logoUrl: generateLogoURL(for: sourceName)
        )
        
        return NewsArticle(
            id: id,
            title: sampleTitles[titleIndex],
            content: sampleContent[contentIndex],
            summary: generateSummary(from: sampleContent[contentIndex]),
            author: sampleAuthors[authorIndex],
            source: newsSource,
            publishedAt: publishedDate,
            category: category,
            imageUrl: URL(string: generateImageURL(for: category)),
            articleUrl: URL(string: "https://example.com/article/\(id)")!,
            isBreaking: Bool.random(),
            tags: generateRandomTags(for: category),
            likeCount: Int.random(in: 0...100),
            shareCount: Int.random(in: 0...50)
        )
    }
    
    private static func generateRandomDate() -> Date {
        let now = Date()
        let thirtyDaysAgo = now.addingTimeInterval(-30 * 24 * 60 * 60)
        let randomTimeInterval = TimeInterval.random(in: 0...now.timeIntervalSince(thirtyDaysAgo))
        return thirtyDaysAgo.addingTimeInterval(randomTimeInterval)
    }
    
    private static func generateSummary(from content: String) -> String {
        let words = content.components(separatedBy: " ")
        var summary = ""
        
        for word in words {
            if summary.count + word.count + 1 > 150 {
                break
            }
            summary += (summary.isEmpty ? "" : " ") + word
        }
        
        return summary + (summary.count < content.count ? "..." : "")
    }
    
    private static func generateImageURL(for category: NewsCategory) -> String {
        let baseURL = "https://picsum.photos/800/600"
        let seed = category.id.hashValue // Use .id instead of .rawValue
        return "\(baseURL)?random=\(abs(seed))"
    }
    
    private static func generateLogoURL(for source: String) -> URL? {
        let baseURL = "https://picsum.photos/100/100"
        let seed = source.hashValue
        return URL(string: "\(baseURL)?random=\(abs(seed))")
    }
    
    private static func generateRandomTags(for category: NewsCategory) -> [String] {
        let allTags = [
            "Breaking", "Exclusive", "Analysis", "Opinion", "Report", "Update", "Live",
            "Politics", "Economy", "Technology", "Science", "Health", "Sports", "Entertainment",
            "World", "Local", "National", "International", "Climate", "Environment", "Energy",
            "Business", "Finance", "Market", "Innovation", "Research", "Development", "AI",
            "Digital", "Social", "Media", "Culture", "Society", "Education", "Future"
        ]
        
        let categorySpecificTags: [NewsCategory: [String]] = [
            .technology: ["AI", "Innovation", "Digital", "Software", "Hardware", "Cybersecurity"],
            .world: ["International", "Global", "Diplomacy", "Conflict", "Peace", "Trade"],
            .business: ["Finance", "Market", "Economy", "Investment", "Corporate", "Startup"],
            .sports: ["Olympics", "Championship", "Tournament", "Athlete", "Team", "Victory"],
            .entertainment: ["Celebrity", "Movie", "Music", "Awards", "Culture", "Arts"],
            .health: ["Medical", "Research", "Treatment", "Wellness", "Mental Health", "Fitness"],
            .science: ["Research", "Discovery", "Innovation", "Study", "Experiment", "Breakthrough"],
            .politics: ["Election", "Government", "Policy", "Legislation", "Campaign", "Vote"]
        ]
        
        var selectedTags = categorySpecificTags[category] ?? []
        
        // Add some random general tags
        let availableGeneralTags = allTags.filter { !selectedTags.contains($0) }
        let numberOfGeneralTags = Int.random(in: 1...3)
        let randomGeneralTags = availableGeneralTags.shuffled().prefix(numberOfGeneralTags)
        selectedTags.append(contentsOf: randomGeneralTags)
        
        // Return a random subset of tags (2-5 tags)
        return Array(selectedTags.shuffled().prefix(Int.random(in: 2...5)))
    }
}
