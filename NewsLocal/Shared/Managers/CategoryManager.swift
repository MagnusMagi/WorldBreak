//
//  CategoryManager.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

/// Manages category standardization and automated article categorization
class CategoryManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var categories: [CategoryStandards.MainCategory] = CategoryStandards.MainCategory.allCases
    @Published var technologySubcategories: [CategoryStandards.TechnologySubcategory] = CategoryStandards.TechnologySubcategory.allCases
    @Published var businessSubcategories: [CategoryStandards.BusinessSubcategory] = CategoryStandards.BusinessSubcategory.allCases
    @Published var scienceSubcategories: [CategoryStandards.ScienceSubcategory] = CategoryStandards.ScienceSubcategory.allCases
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        setupCategoryObservers()
    }
    
    // MARK: - Public Methods
    
    /// Classify an article into the most appropriate category
    func classifyArticle(_ article: NewsArticle) -> CategoryClassificationResult {
        var categoryScores: [(CategoryStandards.MainCategory, Double)] = []
        
        // Calculate scores for all categories
        for category in CategoryStandards.MainCategory.allCases {
            let score = CategoryStandards.CategoryScoring.calculateScore(for: article, category: category)
            if score > 0.1 { // Only include categories with meaningful scores
                categoryScores.append((category, score))
            }
        }
        
        // Sort by score (highest first)
        categoryScores.sort { $0.1 > $1.1 }
        
        guard let primaryCategory = categoryScores.first else {
            return CategoryClassificationResult(
                primaryCategory: .general,
                subcategory: nil,
                confidence: 0.0,
                alternativeCategories: [],
                isBreaking: isBreakingNews(article),
                priority: .medium
            )
        }
        
        // Determine subcategory
        let subcategory = determineSubcategory(for: article, in: primaryCategory.0)
        
        // Check if it's breaking news
        let isBreaking = isBreakingNews(article)
        
        // Determine priority
        let priority = determinePriority(for: article, category: primaryCategory.0)
        
        return CategoryClassificationResult(
            primaryCategory: primaryCategory.0,
            subcategory: subcategory,
            confidence: primaryCategory.1,
            alternativeCategories: Array(categoryScores.dropFirst().prefix(3)),
            isBreaking: isBreaking,
            priority: priority
        )
    }
    
    /// Get recommended layout for a category
    func getLayout(for category: CategoryStandards.MainCategory) -> CategoryLayout {
        return CategoryStandards.LayoutStandards.layout(for: category)
    }
    
    /// Get subcategories for a main category
    func getSubcategories(for category: CategoryStandards.MainCategory) -> [String] {
        switch category {
        case .technology:
            return technologySubcategories.map { $0.displayName }
        case .business:
            return businessSubcategories.map { $0.displayName }
        case .science:
            return scienceSubcategories.map { $0.displayName }
        default:
            return []
        }
    }
    
    /// Get keywords for a category
    func getKeywords(for category: CategoryStandards.MainCategory) -> [String] {
        return CategoryStandards.ClassificationRules.categoryKeywords[category] ?? []
    }
    
    /// Get keywords for a technology subcategory
    func getTechnologyKeywords(for subcategory: CategoryStandards.TechnologySubcategory) -> [String] {
        return subcategory.keywords
    }
    
    /// Validate article categorization
    func validateCategorization(_ article: NewsArticle, expectedCategory: CategoryStandards.MainCategory) -> Bool {
        let classification = classifyArticle(article)
        return classification.primaryCategory == expectedCategory && classification.confidence > 0.5
    }
    
    /// Get category statistics
    func getCategoryStatistics(for articles: [NewsArticle]) -> [CategoryStandards.MainCategory: Int] {
        var statistics: [CategoryStandards.MainCategory: Int] = [:]
        
        for category in CategoryStandards.MainCategory.allCases {
            statistics[category] = 0
        }
        
        for article in articles {
            let classification = classifyArticle(article)
            statistics[classification.primaryCategory, default: 0] += 1
        }
        
        return statistics
    }
    
    /// Get technology subcategory statistics
    func getTechnologySubcategoryStatistics(for articles: [NewsArticle]) -> [CategoryStandards.TechnologySubcategory: Int] {
        var statistics: [CategoryStandards.TechnologySubcategory: Int] = [:]
        
        for subcategory in CategoryStandards.TechnologySubcategory.allCases {
            statistics[subcategory] = 0
        }
        
        let technologyArticles = articles.filter { article in
            let classification = classifyArticle(article)
            return classification.primaryCategory == .technology
        }
        
        for article in technologyArticles {
            if let subcategoryName = determineSubcategory(for: article, in: .technology),
               let subcategory = CategoryStandards.TechnologySubcategory.allCases.first(where: { $0.displayName == subcategoryName }) {
                statistics[subcategory, default: 0] += 1
            }
        }
        
        return statistics
    }
    
    // MARK: - Private Methods
    
    private func setupCategoryObservers() {
        // Setup any necessary observers for category changes
    }
    
    private func determineSubcategory(for article: NewsArticle, in category: CategoryStandards.MainCategory) -> String? {
        switch category {
        case .technology:
            return determineTechnologySubcategory(for: article)
        case .business:
            return determineBusinessSubcategory(for: article)
        case .science:
            return determineScienceSubcategory(for: article)
        default:
            return nil
        }
    }
    
    private func determineTechnologySubcategory(for article: NewsArticle) -> String? {
        let text = "\(article.title) \(article.summary) \(article.content)".lowercased()
        
        var bestMatch: (CategoryStandards.TechnologySubcategory, Int) = (technologySubcategories[0], 0)
        
        for subcategory in technologySubcategories {
            let keywordCount = subcategory.keywords.reduce(0) { count, keyword in
                return count + (text.components(separatedBy: keyword.lowercased()).count - 1)
            }
            
            if keywordCount > bestMatch.1 {
                bestMatch = (subcategory, keywordCount)
            }
        }
        
        return bestMatch.1 > 0 ? bestMatch.0.displayName : nil
    }
    
    private func determineBusinessSubcategory(for article: NewsArticle) -> String? {
        let text = "\(article.title) \(article.summary) \(article.content)".lowercased()
        
        var bestMatch: (CategoryStandards.BusinessSubcategory, Int) = (businessSubcategories[0], 0)
        
        for subcategory in businessSubcategories {
            let keywordCount = subcategory.displayName.lowercased().components(separatedBy: " ").reduce(0) { count, word in
                return count + (text.components(separatedBy: word).count - 1)
            }
            
            if keywordCount > bestMatch.1 {
                bestMatch = (subcategory, keywordCount)
            }
        }
        
        return bestMatch.1 > 0 ? bestMatch.0.displayName : nil
    }
    
    private func determineScienceSubcategory(for article: NewsArticle) -> String? {
        let text = "\(article.title) \(article.summary) \(article.content)".lowercased()
        
        var bestMatch: (CategoryStandards.ScienceSubcategory, Int) = (scienceSubcategories[0], 0)
        
        for subcategory in scienceSubcategories {
            let keywordCount = subcategory.displayName.lowercased().components(separatedBy: " ").reduce(0) { count, word in
                return count + (text.components(separatedBy: word).count - 1)
            }
            
            if keywordCount > bestMatch.1 {
                bestMatch = (subcategory, keywordCount)
            }
        }
        
        return bestMatch.1 > 0 ? bestMatch.0.displayName : nil
    }
    
    private func isBreakingNews(_ article: NewsArticle) -> Bool {
        let text = "\(article.title) \(article.summary)".lowercased()
        
        for keyword in CategoryStandards.ClassificationRules.breakingNewsKeywords {
            if text.contains(keyword.lowercased()) {
                return true
            }
        }
        
        return article.isBreaking
    }
    
    private func determinePriority(for article: NewsArticle, category: CategoryStandards.MainCategory) -> CategoryLayout.Priority {
        let text = "\(article.title) \(article.summary)".lowercased()
        
        // Check for high priority keywords
        let highPriorityKeywords = ["breaking", "urgent", "crisis", "emergency", "critical", "important", "major", "significant"]
        for keyword in highPriorityKeywords {
            if text.contains(keyword) {
                return .high
            }
        }
        
        // Check for technology priority keywords
        if category == .technology {
            let techPriorityKeywords = CategoryStandards.TechnologySubcategory.innovation.keywords
            for keyword in techPriorityKeywords {
                if text.contains(keyword.lowercased()) {
                    return .high
                }
            }
        }
        
        // Default priority based on category
        switch category {
        case .technology, .business, .politics, .world, .health:
            return .high
        case .science, .sports, .entertainment:
            return .medium
        case .local, .general:
            return .low
        }
    }
}

// MARK: - Extensions

extension CategoryManager {
    
    /// Get category color
    func getColor(for category: CategoryStandards.MainCategory) -> Color {
        return category.color
    }
    
    /// Get category icon
    func getIcon(for category: CategoryStandards.MainCategory) -> String {
        return category.icon
    }
    
    /// Get category description
    func getDescription(for category: CategoryStandards.MainCategory) -> String {
        return category.description
    }
    
    /// Get subcategory icon
    func getSubcategoryIcon(for subcategory: CategoryStandards.TechnologySubcategory) -> String {
        return subcategory.icon
    }
    
    /// Get subcategory keywords
    func getSubcategoryKeywords(for subcategory: CategoryStandards.TechnologySubcategory) -> [String] {
        return subcategory.keywords
    }
}

// MARK: - Mock Data

extension CategoryManager {
    
    /// Generate mock category statistics for testing
    func generateMockStatistics() -> [CategoryStandards.MainCategory: Int] {
        return [
            .technology: 45,
            .business: 32,
            .science: 28,
            .health: 25,
            .politics: 38,
            .world: 42,
            .sports: 18,
            .entertainment: 22,
            .local: 15,
            .general: 8
        ]
    }
    
    /// Generate mock technology subcategory statistics
    func generateMockTechnologyStatistics() -> [CategoryStandards.TechnologySubcategory: Int] {
        return [
            .artificialIntelligence: 12,
            .software: 8,
            .gadgets: 6,
            .cybersecurity: 5,
            .mobile: 4,
            .gaming: 3,
            .internet: 2,
            .robotics: 2,
            .blockchain: 1,
            .cloudComputing: 1,
            .dataScience: 1,
            .innovation: 0
        ]
    }
}
