//
//  ProfileViewModel.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/// Simplified ViewModel for ProfileView managing user data and statistics
@MainActor
class ProfileViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var user: User = User.mock
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var recentArticles: [NewsArticle] = []
    @Published var savedArticles: [NewsArticle] = []
    @Published var likedArticles: [NewsArticle] = []
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let newsService: NewsServiceProtocol
    
    // MARK: - Initialization
    
    init(newsService: NewsServiceProtocol = ServiceFactory.shared.newsService) {
        self.newsService = newsService
        loadUserData()
        loadArticleData()
    }
    
    // MARK: - Public Methods
    
    /// Load user data from storage or API
    func loadUserData() {
        isLoading = true
        errorMessage = nil
        
        // For now, use mock data
        // TODO: Replace with actual user service
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.user = User.mock
            self.isLoading = false
        }
    }
    
    /// Load all article data
    func loadArticleData() {
        loadRecentArticles()
        loadSavedArticles()
        loadLikedArticles()
    }
    
    /// Load recent articles
    func loadRecentArticles() {
        newsService.getRecentArticles(limit: 5)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] (completion: Subscribers.Completion<AppError>) in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] articles in
                    self?.recentArticles = articles
                }
            )
            .store(in: &cancellables)
    }
    
    /// Load saved articles
    func loadSavedArticles() {
        newsService.getSavedArticles(limit: 5)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] (completion: Subscribers.Completion<AppError>) in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] articles in
                    self?.savedArticles = articles
                }
            )
            .store(in: &cancellables)
    }
    
    /// Load liked articles
    func loadLikedArticles() {
        // TODO: Implement liked articles service
        // For now, use mock data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.likedArticles = []
        }
    }
    
    /// Refresh all data
    func refreshData() {
        loadUserData()
        loadArticleData()
    }
    
    /// Sign out user
    func signOut() {
        // TODO: Implement actual sign out logic
        print("🚪 User signed out")
    }
    
    /// Delete user account
    func deleteAccount() {
        // TODO: Implement account deletion
        print("🗑️ Account deletion requested")
    }
    
    // MARK: - Computed Properties
    
    /// Formatted reading streak
    var formattedReadingStreak: String {
        if user.statistics.readingStreak == 0 {
            return "No streak yet"
        } else if user.statistics.readingStreak == 1 {
            return "1 day streak"
        } else {
            return "\(user.statistics.readingStreak) day streak"
        }
    }
    
    /// Formatted time spent reading
    var formattedTimeSpent: String {
        return user.statistics.formattedTimeSpentReading
    }
    
    /// Top favorite category
    var topFavoriteCategory: String {
        let sortedCategories = user.statistics.favoriteCategories.sorted { $0.value > $1.value }
        return sortedCategories.first?.key.capitalized ?? "None"
    }
    
    /// User's reading level based on articles read
    var readingLevel: String {
        let articlesRead = user.statistics.articlesRead
        
        switch articlesRead {
        case 0..<10:
            return "Beginner"
        case 10..<50:
            return "Reader"
        case 50..<100:
            return "Avid Reader"
        case 100..<200:
            return "News Enthusiast"
        default:
            return "News Expert"
        }
    }
    
    /// Reading level color using Design System
    var readingLevelColor: Color {
        let articlesRead = user.statistics.articlesRead
        
        switch articlesRead {
        case 0..<10:
            return DesignSystem.Colors.warning
        case 10..<50:
            return DesignSystem.Colors.primary
        case 50..<100:
            return DesignSystem.Colors.info
        case 100..<200:
            return DesignSystem.Colors.success
        default:
            return DesignSystem.Colors.error
        }
    }
}

// MARK: - Extensions

extension ProfileViewModel {
    /// Mock data for previews
    static let mock = ProfileViewModel()
}
