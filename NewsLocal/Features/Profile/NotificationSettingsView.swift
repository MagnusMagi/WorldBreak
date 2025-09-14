//
//  NotificationSettingsView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI
import UserNotifications

/// View for managing notification settings
struct NotificationSettingsView: View {
    @StateObject private var viewModel = NotificationSettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.blue)
                        
                        Text("Notification Settings")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Customize how you receive notifications")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Notification Categories
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Notification Types")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            NotificationToggleRow(
                                title: "Push Notifications",
                                subtitle: "Receive notifications on your device",
                                isOn: $viewModel.pushNotifications,
                                icon: "iphone"
                            )
                            
                            NotificationToggleRow(
                                title: "Email Notifications",
                                subtitle: "Receive notifications via email",
                                isOn: $viewModel.emailNotifications,
                                icon: "envelope"
                            )
                            
                            NotificationToggleRow(
                                title: "Breaking News",
                                subtitle: "Get notified about breaking news",
                                isOn: $viewModel.breakingNews,
                                icon: "exclamationmark.triangle"
                            )
                            
                            NotificationToggleRow(
                                title: "Trending News",
                                subtitle: "Get notified about trending articles",
                                isOn: $viewModel.trendingNews,
                                icon: "chart.line.uptrend.xyaxis"
                            )
                            
                            NotificationToggleRow(
                                title: "Category Updates",
                                subtitle: "Get notified about your favorite categories",
                                isOn: $viewModel.categoryUpdates,
                                icon: "tag"
                            )
                            
                            NotificationToggleRow(
                                title: "Weekly Digest",
                                subtitle: "Receive weekly news summary",
                                isOn: $viewModel.weeklyDigest,
                                icon: "calendar"
                            )
                        }
                    }
                    
                    // Notification Timing
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Notification Timing")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            NotificationTimeRow(
                                title: "Quiet Hours",
                                subtitle: "No notifications during these hours",
                                isEnabled: $viewModel.quietHoursEnabled,
                                startTime: $viewModel.quietHoursStart,
                                endTime: $viewModel.quietHoursEnd
                            )
                            
                            NotificationFrequencyRow(
                                title: "Frequency",
                                subtitle: "How often to receive notifications",
                                selection: $viewModel.notificationFrequency
                            )
                        }
                    }
                    
                    // Test Notification
                    VStack(spacing: 12) {
                        Button(action: {
                            viewModel.sendTestNotification()
                        }) {
                            HStack {
                                Image(systemName: "bell.badge")
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text("Send Test Notification")
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                            )
                        }
                        .disabled(!viewModel.pushNotifications)
                        .opacity(viewModel.pushNotifications ? 1.0 : 0.6)
                        
                        Text("Test your notification settings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Bottom padding
                    Color.clear.frame(height: 50)
                }
                .padding(.horizontal, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveSettings()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            viewModel.loadSettings()
        }
    }
}

// MARK: - Supporting Views

struct NotificationToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct NotificationTimeRow: View {
    let title: String
    let subtitle: String
    @Binding var isEnabled: Bool
    @Binding var startTime: Date
    @Binding var endTime: Date
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "moon")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.blue)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Toggle("", isOn: $isEnabled)
                    .labelsHidden()
            }
            
            if isEnabled {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("From")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("To")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.tertiarySystemBackground))
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct NotificationFrequencyRow: View {
    let title: String
    let subtitle: String
    @Binding var selection: NotificationFrequency
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "clock")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Picker("Frequency", selection: $selection) {
                ForEach(NotificationFrequency.allCases, id: \.self) { frequency in
                    Text(frequency.displayName).tag(frequency)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

// MARK: - Enums

enum NotificationFrequency: String, CaseIterable {
    case immediate = "immediate"
    case hourly = "hourly"
    case daily = "daily"
    case weekly = "weekly"
    
    var displayName: String {
        switch self {
        case .immediate:
            return "Immediate"
        case .hourly:
            return "Hourly"
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        }
    }
}

// MARK: - Preview

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}
