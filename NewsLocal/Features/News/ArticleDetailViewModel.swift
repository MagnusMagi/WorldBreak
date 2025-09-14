//
//  ArticleDetailViewModel.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel for enhanced article detail view
@MainActor
class ArticleDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var article: NewsArticle
    @Published var readingProgress: Double = 0.0
    @Published var isBookmarked: Bool = false
    @Published var isLiked: Bool = false
    @Published var likeCount: Int = 0
    @Published var shareCount: Int = 0
    @Published var viewCount: Int = 0
    @Published var readingTimeRemaining: Int = 0
    @Published var currentImageIndex: Int = 0
    @Published var showingImageGallery: Bool = false
    @Published var showingShareSheet: Bool = false
    @Published var isVideoPlaying: Bool = false
    @Published var videoDuration: TimeInterval = 0
    @Published var currentVideoTime: TimeInterval = 0
    @Published var relatedArticles: [NewsArticle] = []
    @Published var isLoadingRelated: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var scrollOffset: CGFloat = 0
    private var contentHeight: CGFloat = 0
    private var viewportHeight: CGFloat = 0
    private var readingStartTime: Date?
    private var lastReadingPosition: CGFloat = 0
    private let bookmarkManager = BookmarkManager()
    private let newsService: NewsServiceProtocol
    
    // MARK: - Initialization
    
    init(article: NewsArticle, newsService: NewsServiceProtocol = ServiceFactory.shared.newsService) {
        self.article = article
        self.newsService = newsService
        
        // Initialize properties from article
        self.likeCount = article.likeCount
        self.shareCount = article.shareCount
        self.readingTimeRemaining = article.readingTime
        
        setupInitialState()
        startReadingSession()
        loadRelatedArticles()
    }
    
    // MARK: - Public Methods
    
    /// Update reading progress based on scroll position
    func updateReadingProgress(scrollOffset: CGFloat, contentHeight: CGFloat, viewportHeight: CGFloat) {
        self.scrollOffset = scrollOffset
        self.contentHeight = contentHeight
        self.viewportHeight = viewportHeight
        
        let scrollableHeight = max(0, contentHeight - viewportHeight)
        let progress = scrollableHeight > 0 ? min(1.0, max(0.0, scrollOffset / scrollableHeight)) : 0.0
        
        readingProgress = progress
        
        // Update remaining reading time
        updateRemainingReadingTime()
        
        // Track reading position for analytics
        trackReadingPosition()
    }
    
    /// Toggle bookmark status
    func toggleBookmark() {
        if isBookmarked {
            removeBookmark()
        } else {
            addBookmark()
        }
    }
    
    /// Toggle like status
    func toggleLike() {
        isLiked.toggle()
        likeCount += isLiked ? 1 : -1
        
        // Update article
        var updatedArticle = article
        updatedArticle = NewsArticle(
            id: updatedArticle.id,
            title: updatedArticle.title,
            content: updatedArticle.content,
            summary: updatedArticle.summary,
            author: updatedArticle.author,
            source: updatedArticle.source,
            publishedAt: updatedArticle.publishedAt,
            category: updatedArticle.category,
            imageUrl: updatedArticle.imageUrl,
            articleUrl: updatedArticle.articleUrl,
            isBreaking: updatedArticle.isBreaking,
            tags: updatedArticle.tags,
            likeCount: likeCount,
            shareCount: shareCount
        )
        article = updatedArticle
        
        // Track like action
        trackLikeAction()
    }
    
    /// Share article
    func shareArticle() {
        showingShareSheet = true
        shareCount += 1
        
        // Update article
        var updatedArticle = article
        updatedArticle = NewsArticle(
            id: updatedArticle.id,
            title: updatedArticle.title,
            content: updatedArticle.content,
            summary: updatedArticle.summary,
            author: updatedArticle.author,
            source: updatedArticle.source,
            publishedAt: updatedArticle.publishedAt,
            category: updatedArticle.category,
            imageUrl: updatedArticle.imageUrl,
            articleUrl: updatedArticle.articleUrl,
            isBreaking: updatedArticle.isBreaking,
            tags: updatedArticle.tags,
            likeCount: likeCount,
            shareCount: shareCount
        )
        article = updatedArticle
        
        // Track share action
        trackShareAction()
    }
    
    /// Show image gallery
    func showImageGallery(at index: Int = 0) {
        currentImageIndex = index
        showingImageGallery = true
    }
    
    /// Load related articles
    func loadRelatedArticles() {
        isLoadingRelated = true
        errorMessage = nil
        
        newsService.fetchRelatedArticles(articleId: article.id, category: article.category)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingRelated = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] articles in
                    self?.relatedArticles = articles
                }
            )
            .store(in: &cancellables)
    }
    
    /// Get article images for gallery
    var articleImages: [URL] {
        var images: [URL] = []
        if let imageUrl = article.imageUrl {
            images.append(imageUrl)
        }
        // Add more images if available in the future
        return images
    }
    
    /// Get formatted reading progress
    var formattedReadingProgress: String {
        let percentage = Int(readingProgress * 100)
        return "\(percentage)%"
    }
    
    /// Get estimated time remaining
    var estimatedTimeRemaining: String {
        if readingTimeRemaining <= 0 {
            return "Tamamlandı"
        }
        return "\(readingTimeRemaining) dk kaldı"
    }
    
    // MARK: - Private Methods
    
    private func setupInitialState() {
        // Check if article is bookmarked
        isBookmarked = bookmarkManager.isBookmarked(article.id)
        
        // Initialize view count
        viewCount = article.likeCount + article.shareCount // Mock view count
        
        // Start reading session
        readingStartTime = Date()
    }
    
    private func startReadingSession() {
        // Track article view
        trackArticleView()
    }
    
    private func addBookmark() {
        bookmarkManager.addBookmark(article)
        isBookmarked = true
        
        // Show success feedback
        showBookmarkFeedback(isAdded: true)
    }
    
    private func removeBookmark() {
        bookmarkManager.removeBookmark(article.id)
        isBookmarked = false
        
        // Show success feedback
        showBookmarkFeedback(isAdded: false)
    }
    
    private func updateRemainingReadingTime() {
        let totalReadingTime = article.readingTime
        let remainingTime = Int(Double(totalReadingTime) * (1.0 - readingProgress))
        readingTimeRemaining = max(0, remainingTime)
    }
    
    private func trackReadingPosition() {
        // Track reading position for analytics
        let currentPosition = scrollOffset
        if abs(currentPosition - lastReadingPosition) > 100 { // Track every 100 points
            lastReadingPosition = currentPosition
            // Send analytics event
            trackReadingProgress()
        }
    }
    
    private func showBookmarkFeedback(isAdded: Bool) {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Could show a toast or snackbar here
        print("📖 Article \(isAdded ? "bookmarked" : "removed from bookmarks")")
    }
    
    // MARK: - Analytics Methods
    
    private func trackArticleView() {
        // Track article view for analytics
        print("📊 Article viewed: \(article.title)")
    }
    
    private func trackReadingProgress() {
        // Track reading progress for analytics
        print("📊 Reading progress: \(formattedReadingProgress)")
    }
    
    private func trackLikeAction() {
        // Track like action for analytics
        print("📊 Article liked: \(article.title)")
    }
    
    private func trackShareAction() {
        // Track share action for analytics
        print("📊 Article shared: \(article.title)")
    }
}

// MARK: - BookmarkManager

/// Simple bookmark manager for local storage
class BookmarkManager {
    private let userDefaults = UserDefaults.standard
    private let bookmarksKey = "saved_bookmarks"
    
    /// Check if article is bookmarked
    func isBookmarked(_ articleId: String) -> Bool {
        let bookmarkedIds = getBookmarkedIds()
        return bookmarkedIds.contains(articleId)
    }
    
    /// Add article to bookmarks
    func addBookmark(_ article: NewsArticle) {
        var bookmarkedIds = getBookmarkedIds()
        if !bookmarkedIds.contains(article.id) {
            bookmarkedIds.append(article.id)
            saveBookmarkedIds(bookmarkedIds)
        }
    }
    
    /// Remove article from bookmarks
    func removeBookmark(_ articleId: String) {
        var bookmarkedIds = getBookmarkedIds()
        bookmarkedIds.removeAll { $0 == articleId }
        saveBookmarkedIds(bookmarkedIds)
    }
    
    /// Get all bookmarked article IDs
    func getBookmarkedIds() -> [String] {
        return userDefaults.stringArray(forKey: bookmarksKey) ?? []
    }
    
    /// Save bookmarked article IDs
    private func saveBookmarkedIds(_ ids: [String]) {
        userDefaults.set(ids, forKey: bookmarksKey)
    }
}
