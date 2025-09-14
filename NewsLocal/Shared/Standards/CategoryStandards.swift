//
//  CategoryStandards.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import SwiftUI

/// Comprehensive category standardization system for news articles
/// Defines main categories, subcategories, and categorization rules
struct CategoryStandards {
    
    // MARK: - Main Categories
    
    /// Main news categories with standardized definitions
    enum MainCategory: String, CaseIterable, Identifiable, Codable {
        case general = "general"
        case technology = "technology"
        case business = "business"
        case science = "science"
        case health = "health"
        case sports = "sports"
        case entertainment = "entertainment"
        case politics = "politics"
        case world = "world"
        case local = "local"
        
        var id: String { rawValue }
        
        var displayName: String {
            switch self {
            case .general: return "General"
            case .technology: return "Technology"
            case .business: return "Business"
            case .science: return "Science"
            case .health: return "Health"
            case .sports: return "Sports"
            case .entertainment: return "Entertainment"
            case .politics: return "Politics"
            case .world: return "World"
            case .local: return "Local"
            }
        }
        
        var icon: String {
            switch self {
            case .general: return "newspaper"
            case .technology: return "laptopcomputer"
            case .business: return "briefcase"
            case .science: return "atom"
            case .health: return "heart"
            case .sports: return "sportscourt"
            case .entertainment: return "tv"
            case .politics: return "building.2"
            case .world: return "globe"
            case .local: return "location"
            }
        }
        
        var color: Color {
            switch self {
            case .general: return .gray
            case .technology: return .purple
            case .business: return .blue
            case .science: return .green
            case .health: return .red
            case .sports: return .orange
            case .entertainment: return .pink
            case .politics: return .indigo
            case .world: return .teal
            case .local: return .mint
            }
        }
        
        var description: String {
            switch self {
            case .general: return "General news and current events"
            case .technology: return "Technology, gadgets, software, and digital innovation"
            case .business: return "Business, finance, economy, and corporate news"
            case .science: return "Scientific research, discoveries, and academic news"
            case .health: return "Health, medicine, wellness, and medical research"
            case .sports: return "Sports, athletics, and competitive events"
            case .entertainment: return "Entertainment, movies, music, and celebrity news"
            case .politics: return "Political news, government, and policy"
            case .world: return "International news and global events"
            case .local: return "Local news and community events"
            }
        }
    }
    
    // MARK: - Technology Subcategories
    
    /// Technology subcategories for detailed classification
    enum TechnologySubcategory: String, CaseIterable, Identifiable, Codable {
        case gadgets = "gadgets"
        case software = "software"
        case artificialIntelligence = "ai"
        case cybersecurity = "cybersecurity"
        case mobile = "mobile"
        case gaming = "gaming"
        case internet = "internet"
        case robotics = "robotics"
        case blockchain = "blockchain"
        case cloudComputing = "cloud_computing"
        case dataScience = "data_science"
        case innovation = "innovation"
        
        var id: String { rawValue }
        
        var displayName: String {
            switch self {
            case .gadgets: return "Gadgets"
            case .software: return "Software"
            case .artificialIntelligence: return "Artificial Intelligence"
            case .cybersecurity: return "Cybersecurity"
            case .mobile: return "Mobile"
            case .gaming: return "Gaming"
            case .internet: return "Internet"
            case .robotics: return "Robotics"
            case .blockchain: return "Blockchain"
            case .cloudComputing: return "Cloud Computing"
            case .dataScience: return "Data Science"
            case .innovation: return "Innovation"
            }
        }
        
        var icon: String {
            switch self {
            case .gadgets: return "iphone"
            case .software: return "app"
            case .artificialIntelligence: return "brain.head.profile"
            case .cybersecurity: return "shield"
            case .mobile: return "phone"
            case .gaming: return "gamecontroller"
            case .internet: return "wifi"
            case .robotics: return "robot"
            case .blockchain: return "link"
            case .cloudComputing: return "cloud"
            case .dataScience: return "chart.bar"
            case .innovation: return "lightbulb"
            }
        }
        
        var keywords: [String] {
            switch self {
            case .gadgets: return ["gadget", "device", "hardware", "smartphone", "tablet", "laptop", "computer"]
            case .software: return ["software", "app", "application", "program", "code", "development", "programming"]
            case .artificialIntelligence: return ["ai", "artificial intelligence", "machine learning", "neural network", "deep learning", "automation"]
            case .cybersecurity: return ["cybersecurity", "security", "hack", "privacy", "encryption", "malware", "virus"]
            case .mobile: return ["mobile", "smartphone", "ios", "android", "app store", "mobile app"]
            case .gaming: return ["gaming", "game", "video game", "esports", "console", "pc gaming"]
            case .internet: return ["internet", "web", "online", "website", "browser", "social media"]
            case .robotics: return ["robot", "robotics", "automation", "drone", "autonomous"]
            case .blockchain: return ["blockchain", "cryptocurrency", "bitcoin", "ethereum", "crypto", "nft"]
            case .cloudComputing: return ["cloud", "aws", "azure", "google cloud", "server", "hosting"]
            case .dataScience: return ["data", "analytics", "big data", "statistics", "database"]
            case .innovation: return ["innovation", "startup", "tech", "breakthrough", "invention"]
            }
        }
    }
    
    // MARK: - Business Subcategories
    
    /// Business subcategories for detailed classification
    enum BusinessSubcategory: String, CaseIterable, Identifiable, Codable {
        case finance = "finance"
        case economy = "economy"
        case markets = "markets"
        case startups = "startups"
        case corporate = "corporate"
        case realEstate = "real_estate"
        case energy = "energy"
        case automotive = "automotive"
        case retail = "retail"
        case manufacturing = "manufacturing"
        
        var id: String { rawValue }
        
        var displayName: String {
            switch self {
            case .finance: return "Finance"
            case .economy: return "Economy"
            case .markets: return "Markets"
            case .startups: return "Startups"
            case .corporate: return "Corporate"
            case .realEstate: return "Real Estate"
            case .energy: return "Energy"
            case .automotive: return "Automotive"
            case .retail: return "Retail"
            case .manufacturing: return "Manufacturing"
            }
        }
        
        var icon: String {
            switch self {
            case .finance: return "dollarsign.circle"
            case .economy: return "chart.line.uptrend.xyaxis"
            case .markets: return "chart.bar"
            case .startups: return "rocket"
            case .corporate: return "building.2"
            case .realEstate: return "house"
            case .energy: return "bolt"
            case .automotive: return "car"
            case .retail: return "bag"
            case .manufacturing: return "gear"
            }
        }
    }
    
    // MARK: - Science Subcategories
    
    /// Science subcategories for detailed classification
    enum ScienceSubcategory: String, CaseIterable, Identifiable, Codable {
        case physics = "physics"
        case chemistry = "chemistry"
        case biology = "biology"
        case astronomy = "astronomy"
        case climate = "climate"
        case space = "space"
        case environment = "environment"
        case research = "research"
        case discovery = "discovery"
        
        var id: String { rawValue }
        
        var displayName: String {
            switch self {
            case .physics: return "Physics"
            case .chemistry: return "Chemistry"
            case .biology: return "Biology"
            case .astronomy: return "Astronomy"
            case .climate: return "Climate"
            case .space: return "Space"
            case .environment: return "Environment"
            case .research: return "Research"
            case .discovery: return "Discovery"
            }
        }
        
        var icon: String {
            switch self {
            case .physics: return "atom"
            case .chemistry: return "flask"
            case .biology: return "leaf"
            case .astronomy: return "star"
            case .climate: return "thermometer"
            case .space: return "moon"
            case .environment: return "globe"
            case .research: return "magnifyingglass"
            case .discovery: return "lightbulb"
            }
        }
    }
    
    // MARK: - Category Classification Rules
    
    /// Rules for automatic article categorization
    struct ClassificationRules {
        
        /// Keywords that strongly indicate a specific category
        static let categoryKeywords: [MainCategory: [String]] = [
            .technology: ["technology", "tech", "software", "hardware", "digital", "computer", "internet", "ai", "artificial intelligence", "app", "gadget", "device", "innovation", "startup", "cybersecurity", "blockchain", "cloud", "data", "programming", "coding", "development"],
            .business: ["business", "finance", "economy", "market", "stock", "investment", "corporate", "company", "revenue", "profit", "earnings", "trading", "banking", "startup", "entrepreneur", "ceo", "cfo", "ipo", "merger", "acquisition"],
            .science: ["science", "research", "study", "discovery", "experiment", "scientific", "physics", "chemistry", "biology", "astronomy", "space", "climate", "environment", "laboratory", "scientist", "researcher", "findings", "hypothesis", "theory"],
            .health: ["health", "medical", "medicine", "doctor", "patient", "hospital", "disease", "treatment", "therapy", "vaccine", "drug", "pharmaceutical", "wellness", "fitness", "nutrition", "mental health", "covid", "pandemic", "surgery"],
            .sports: ["sports", "game", "match", "player", "team", "championship", "tournament", "olympics", "football", "basketball", "soccer", "baseball", "tennis", "golf", "athlete", "coach", "score", "victory", "defeat"],
            .entertainment: ["entertainment", "movie", "film", "music", "celebrity", "actor", "singer", "artist", "show", "series", "tv", "television", "award", "oscar", "grammy", "festival", "concert", "theater", "broadway"],
            .politics: ["politics", "political", "government", "election", "vote", "president", "senator", "congress", "parliament", "policy", "law", "bill", "legislation", "democrat", "republican", "campaign", "candidate", "minister", "prime minister"],
            .world: ["world", "international", "global", "country", "nation", "foreign", "diplomacy", "trade", "war", "peace", "conflict", "crisis", "summit", "treaty", "united nations", "nato", "european union", "brexit"],
            .local: ["local", "city", "town", "community", "neighborhood", "municipal", "mayor", "council", "police", "fire", "school", "hospital", "traffic", "construction", "development", "zoning", "budget", "tax"]
        ]
        
        /// Keywords that indicate breaking news priority
        static let breakingNewsKeywords = ["breaking", "urgent", "alert", "emergency", "crisis", "disaster", "attack", "accident", "death", "arrest", "resignation", "election", "victory", "defeat", "announcement", "decision"]
        
        /// Keywords that indicate high priority for technology category
        static let technologyPriorityKeywords = ["breakthrough", "revolutionary", "first", "new", "launch", "release", "update", "upgrade", "innovation", "discovery", "invention", "patent", "acquisition", "merger", "partnership"]
    }
    
    // MARK: - Category Scoring System
    
    /// Scoring system for article categorization
    struct CategoryScoring {
        
        /// Calculate category score for an article
        static func calculateScore(for article: NewsArticle, category: MainCategory) -> Double {
            var score = 0.0
            
            // Title analysis (40% weight)
            let titleScore = analyzeText(article.title, for: category) * 0.4
            score += titleScore
            
            // Content analysis (30% weight)
            let contentScore = analyzeText(article.content, for: category) * 0.3
            score += contentScore
            
            // Summary analysis (20% weight)
            let summaryScore = analyzeText(article.summary, for: category) * 0.2
            score += summaryScore
            
            // Tags analysis (10% weight)
            let tagsScore = analyzeTags(article.tags, for: category) * 0.1
            score += tagsScore
            
            return min(score, 1.0) // Cap at 1.0
        }
        
        /// Analyze text content for category keywords
        private static func analyzeText(_ text: String, for category: MainCategory) -> Double {
            guard let keywords = ClassificationRules.categoryKeywords[category] else { return 0.0 }
            
            let lowercaseText = text.lowercased()
            var matchCount = 0
            var totalKeywords = keywords.count
            
            for keyword in keywords {
                if lowercaseText.contains(keyword.lowercased()) {
                    matchCount += 1
                }
            }
            
            return Double(matchCount) / Double(totalKeywords)
        }
        
        /// Analyze tags for category relevance
        private static func analyzeTags(_ tags: [String], for category: MainCategory) -> Double {
            guard let keywords = ClassificationRules.categoryKeywords[category] else { return 0.0 }
            
            let lowercaseTags = tags.map { $0.lowercased() }
            var matchCount = 0
            
            for tag in lowercaseTags {
                for keyword in keywords {
                    if tag.contains(keyword.lowercased()) {
                        matchCount += 1
                        break
                    }
                }
            }
            
            return tags.isEmpty ? 0.0 : Double(matchCount) / Double(tags.count)
        }
    }
    
    // MARK: - Category Layout Standards
    
    /// Layout standards for different categories
    struct LayoutStandards {
        
        /// Get recommended layout for category
        static func layout(for category: MainCategory) -> CategoryLayout {
            switch category {
            case .technology:
                return CategoryLayout(
                    cardType: .standard,
                    imageAspectRatio: 16/9,
                    showMetadata: true,
                    showTags: true,
                    maxTitleLines: 3,
                    maxSummaryLines: 2,
                    priority: .high
                )
            case .business:
                return CategoryLayout(
                    cardType: .compact,
                    imageAspectRatio: 4/3,
                    showMetadata: true,
                    showTags: false,
                    maxTitleLines: 2,
                    maxSummaryLines: 1,
                    priority: .high
                )
            case .science:
                return CategoryLayout(
                    cardType: .standard,
                    imageAspectRatio: 16/9,
                    showMetadata: true,
                    showTags: true,
                    maxTitleLines: 3,
                    maxSummaryLines: 2,
                    priority: .medium
                )
            case .health:
                return CategoryLayout(
                    cardType: .standard,
                    imageAspectRatio: 4/3,
                    showMetadata: true,
                    showTags: true,
                    maxTitleLines: 3,
                    maxSummaryLines: 2,
                    priority: .high
                )
            case .sports:
                return CategoryLayout(
                    cardType: .compact,
                    imageAspectRatio: 16/9,
                    showMetadata: true,
                    showTags: false,
                    maxTitleLines: 2,
                    maxSummaryLines: 1,
                    priority: .medium
                )
            case .entertainment:
                return CategoryLayout(
                    cardType: .standard,
                    imageAspectRatio: 16/9,
                    showMetadata: true,
                    showTags: true,
                    maxTitleLines: 2,
                    maxSummaryLines: 1,
                    priority: .medium
                )
            case .politics:
                return CategoryLayout(
                    cardType: .standard,
                    imageAspectRatio: 4/3,
                    showMetadata: true,
                    showTags: false,
                    maxTitleLines: 3,
                    maxSummaryLines: 2,
                    priority: .high
                )
            case .world:
                return CategoryLayout(
                    cardType: .standard,
                    imageAspectRatio: 16/9,
                    showMetadata: true,
                    showTags: true,
                    maxTitleLines: 3,
                    maxSummaryLines: 2,
                    priority: .high
                )
            case .local:
                return CategoryLayout(
                    cardType: .compact,
                    imageAspectRatio: 4/3,
                    showMetadata: true,
                    showTags: false,
                    maxTitleLines: 2,
                    maxSummaryLines: 1,
                    priority: .medium
                )
            case .general:
                return CategoryLayout(
                    cardType: .standard,
                    imageAspectRatio: 16/9,
                    showMetadata: true,
                    showTags: true,
                    maxTitleLines: 3,
                    maxSummaryLines: 2,
                    priority: .medium
                )
            }
        }
    }
}

// MARK: - Supporting Types

/// Category layout configuration
struct CategoryLayout {
    let cardType: CardType
    let imageAspectRatio: Double
    let showMetadata: Bool
    let showTags: Bool
    let maxTitleLines: Int
    let maxSummaryLines: Int
    let priority: Priority
    
    enum CardType {
        case standard
        case compact
        case hero
        case minimalist
    }
    
    enum Priority {
        case low
        case medium
        case high
        case critical
    }
}

/// Category classification result
struct CategoryClassificationResult {
    let primaryCategory: CategoryStandards.MainCategory
    let subcategory: String?
    let confidence: Double
    let alternativeCategories: [(CategoryStandards.MainCategory, Double)]
    let isBreaking: Bool
    let priority: CategoryLayout.Priority
}
