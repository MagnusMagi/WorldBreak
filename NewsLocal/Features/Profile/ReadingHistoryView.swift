//
//  ReadingHistoryView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// View for displaying user's reading history
struct ReadingHistoryView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with statistics
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Reading History")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("\(viewModel.recentArticles.count) recent articles")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Done") {
                            dismiss()
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Quick stats
                    HStack(spacing: 20) {
                        StatisticItem(
                            title: "Today",
                            value: "\(todayArticleCount)",
                            color: .blue
                        )
                        
                        StatisticItem(
                            title: "This Week",
                            value: "\(thisWeekArticleCount)",
                            color: .green
                        )
                        
                        StatisticItem(
                            title: "Total",
                            value: "\(viewModel.user.statistics.articlesRead)",
                            color: .purple
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
                .background(Color(.systemBackground))
                
                // Articles list
                if viewModel.recentArticles.isEmpty {
                    EmptyStateView(
                        title: "No Reading History",
                        message: "Start reading articles to see your history here",
                        actionTitle: nil,
                        action: nil
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.recentArticles) { article in
                                ReadingHistoryItem(article: article)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.loadRecentArticles()
        }
    }
    
    // MARK: - Computed Properties
    
    private var todayArticleCount: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return viewModel.recentArticles.filter { article in
            Calendar.current.isDate(article.publishedAt, inSameDayAs: today)
        }.count
    }
    
    private var thisWeekArticleCount: Int {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return viewModel.recentArticles.filter { article in
            article.publishedAt >= weekAgo
        }.count
    }
}

// MARK: - Supporting Views

struct StatisticItem: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ReadingHistoryItem: View {
    let article: NewsArticle
    
    var body: some View {
        HStack(spacing: 12) {
            // Article image
            AsyncImage(url: article.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.secondary)
                    )
            }
            .frame(width: 80, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Article content
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(article.source.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(article.publishedAt.timeAgoDisplay)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Reading time indicator
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption2)
                        Text("\(article.readingTime) min")
                            .font(.caption2)
                    }
                    .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

// EmptyStateView moved to View+Extensions.swift

// MARK: - Extensions

extension Date {
    var timeAgoDisplay: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

// MARK: - Preview

struct ReadingHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingHistoryView()
    }
}
