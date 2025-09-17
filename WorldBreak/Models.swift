//
//  Models.swift
//  WorldBreak
//
//  Created by Magnus Magi on 16.09.2025.
//

import SwiftUI
import Foundation

// MARK: - Category Model
struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    var isSelected: Bool = false
    
    // Hashable conformance - Color is not Hashable, so we only use id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
    
    static let allCategories = [
        Category(name: "Teknoloji", icon: "laptopcomputer", color: AppColors.technology),
        Category(name: "Spor", icon: "sportscourt", color: AppColors.sports),
        Category(name: "Ekonomi", icon: "chart.line.uptrend.xyaxis", color: AppColors.economy),
        Category(name: "Sağlık", icon: "heart.fill", color: AppColors.health),
        Category(name: "Eğitim", icon: "book.fill", color: AppColors.education),
        Category(name: "Sanat", icon: "paintbrush.fill", color: AppColors.art),
        Category(name: "Politika", icon: "building.2.fill", color: AppColors.politics),
        Category(name: "Dünya", icon: "globe", color: AppColors.world),
        Category(name: "Bilim", icon: "atom", color: AppColors.science),
        Category(name: "Çevre", icon: "leaf.fill", color: AppColors.environment),
        Category(name: "Seyahat", icon: "airplane", color: AppColors.travel),
        Category(name: "Yemek", icon: "fork.knife", color: AppColors.food),
        Category(name: "Moda", icon: "tshirt.fill", color: AppColors.fashion),
        Category(name: "Müzik", icon: "music.note", color: AppColors.music),
        Category(name: "Sinema", icon: "tv.fill", color: AppColors.cinema),
        Category(name: "Oyun", icon: "gamecontroller.fill", color: AppColors.gaming)
    ]
}

// MARK: - Theme Model
struct Theme: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let isDark: Bool?
    let primaryColor: Color
    let description: String
    
    // Hashable conformance - Color is not Hashable, so we only use id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        lhs.id == rhs.id
    }
    
    static let allThemes = [
        Theme(name: "Açık", isDark: false, primaryColor: AppColors.primary, description: "Açık renk teması"),
        Theme(name: "Koyu", isDark: true, primaryColor: AppColors.primary, description: "Koyu renk teması"),
        Theme(name: "Sistem", isDark: nil, primaryColor: AppColors.primary, description: "Sistem temasını takip eder")
    ]
}

// MARK: - News Article Model
struct NewsArticle: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let summary: String
    let category: Category
    let publishedAt: Date
    let imageURL: String?
    let source: String
    var isFavorite: Bool = false
    
    // Mock data for development
    static let mockArticles = [
        NewsArticle(
            title: "Yeni iPhone 16 Özellikleri Açıklandı",
            summary: "Apple'ın yeni iPhone 16 serisi, gelişmiş kamera sistemi ve daha hızlı işlemci ile geliyor.",
            category: Category.allCategories[0],
            publishedAt: Date(),
            imageURL: nil,
            source: "TechNews"
        ),
        NewsArticle(
            title: "Champions League Finali Bu Gece",
            summary: "Real Madrid ve Manchester City arasındaki final maçı bu gece oynanacak.",
            category: Category.allCategories[1],
            publishedAt: Date().addingTimeInterval(-3600),
            imageURL: nil,
            source: "SporHaber"
        ),
        NewsArticle(
            title: "Borsa Yükselişte",
            summary: "BIST 100 endeksi günü yüzde 2.5 artışla kapattı.",
            category: Category.allCategories[2],
            publishedAt: Date().addingTimeInterval(-7200),
            imageURL: nil,
            source: "EkonomiGazetesi"
        )
    ]
}

