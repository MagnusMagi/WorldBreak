//
//  PrivacySettingsView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Complete privacy and data settings view
struct PrivacySettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PrivacySettingsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.green)
                        
                        Text("Privacy & Data")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Control your data and privacy settings")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Data Sharing
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Data Sharing")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            SettingsToggleRow(
                                icon: "chart.bar.fill",
                                title: "Usage Analytics",
                                subtitle: "Help improve the app by sharing usage data",
                                isOn: $viewModel.shareUsageData
                            )
                            
                            SettingsToggleRow(
                                icon: "book.fill",
                                title: "Reading History",
                                subtitle: "Share your reading preferences for better recommendations",
                                isOn: $viewModel.shareReadingHistory
                            )
                            
                            SettingsToggleRow(
                                icon: "location.fill",
                                title: "Location Data",
                                subtitle: "Share location for local news and weather",
                                isOn: $viewModel.shareLocation
                            )
                            
                            SettingsToggleRow(
                                icon: "target",
                                title: "Personalized Ads",
                                subtitle: "Show ads based on your interests",
                                isOn: $viewModel.personalizedAds
                            )
                        }
                    }
                    
                    // Account Privacy
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Account Privacy")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            PrivacyOptionRow(
                                title: "Account Visibility",
                                subtitle: "Control who can see your profile",
                                currentValue: viewModel.accountVisibility.displayName,
                                icon: "eye.fill",
                                color: .blue
                            ) {
                                viewModel.showingVisibilityPicker = true
                            }
                            
                            PrivacyOptionRow(
                                title: "Data Retention",
                                subtitle: "How long to keep your data",
                                currentValue: viewModel.dataRetention.displayName,
                                icon: "clock.fill",
                                color: .orange
                            ) {
                                viewModel.showingRetentionPicker = true
                            }
                        }
                    }
                    
                    // Data Management
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Data Management")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                viewModel.exportData()
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.blue)
                                        .frame(width: 24, height: 24)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Export Data")
                                            .font(.body)
                                            .fontWeight(.medium)
                                            .foregroundColor(.primary)
                                        
                                        Text("Download a copy of your data")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                viewModel.clearData()
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .frame(width: 24, height: 24)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Clear All Data")
                                            .font(.body)
                                            .fontWeight(.medium)
                                            .foregroundColor(.red)
                                        
                                        Text("Remove all your data from this device")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    // Privacy Policy
                    VStack(spacing: 12) {
                        Button(action: {
                            viewModel.openPrivacyPolicy()
                        }) {
                            HStack {
                                Image(systemName: "doc.text")
                                    .foregroundColor(.blue)
                                    .frame(width: 24, height: 24)
                                
                                Text("Privacy Policy")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.blue)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.1))
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
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
        .actionSheet(isPresented: $viewModel.showingVisibilityPicker) {
            ActionSheet(
                title: Text("Account Visibility"),
                buttons: AccountVisibility.allCases.map { visibility in
                    .default(Text(visibility.displayName)) {
                        viewModel.accountVisibility = visibility
                    }
                } + [.cancel()]
            )
        }
        .actionSheet(isPresented: $viewModel.showingRetentionPicker) {
            ActionSheet(
                title: Text("Data Retention"),
                buttons: DataRetentionPeriod.allCases.map { period in
                    .default(Text(period.displayName)) {
                        viewModel.dataRetention = period
                    }
                } + [.cancel()]
            )
        }
        .alert("Data Exported", isPresented: $viewModel.showExportSuccess) {
            Button("OK") { }
        } message: {
            Text("Your data has been exported successfully.")
        }
        .alert("Data Cleared", isPresented: $viewModel.showClearSuccess) {
            Button("OK") { }
        } message: {
            Text("All your data has been cleared from this device.")
        }
        .onAppear {
            viewModel.loadSettings()
        }
    }
}

struct PrivacySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacySettingsView()
    }
}
