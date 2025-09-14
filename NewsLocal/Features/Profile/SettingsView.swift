//
//  SettingsView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Main settings view with all app settings
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingNotificationSettings = false
    @State private var showingThemeSettings = false
    @State private var showingPrivacySettings = false
    @State private var showingHelpSupport = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "gear")
                            .font(.system(size: 48))
                            .foregroundColor(.blue)
                        
                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Customize your NewsLocal experience")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Settings Categories
                    VStack(spacing: 16) {
                        // Notifications
                        SettingsSection(
                            title: "Notifications",
                            icon: "bell.fill",
                            color: .blue
                        ) {
                            SettingsRow(
                                icon: "bell",
                                title: "Notification Settings",
                                subtitle: "Manage push and email notifications",
                                action: {
                                    showingNotificationSettings = true
                                }
                            )
                        }
                        
                        // Appearance
                        SettingsSection(
                            title: "Appearance",
                            icon: "paintbrush.fill",
                            color: .purple
                        ) {
                            SettingsRow(
                                icon: "moon.fill",
                                title: "Theme & Display",
                                subtitle: "Dark mode, font size, and display options",
                                action: {
                                    showingThemeSettings = true
                                }
                            )
                        }
                        
                        // Privacy & Security
                        SettingsSection(
                            title: "Privacy & Security",
                            icon: "lock.fill",
                            color: .green
                        ) {
                            SettingsRow(
                                icon: "hand.raised.fill",
                                title: "Privacy Settings",
                                subtitle: "Data sharing and privacy controls",
                                action: {
                                    showingPrivacySettings = true
                                }
                            )
                        }
                        
                        // Support
                        SettingsSection(
                            title: "Support",
                            icon: "questionmark.circle.fill",
                            color: .orange
                        ) {
                            SettingsRow(
                                icon: "questionmark.circle",
                                title: "Help & Support",
                                subtitle: "Get help and contact support",
                                action: {
                                    showingHelpSupport = true
                                }
                            )
                            
                            SettingsRow(
                                icon: "info.circle",
                                title: "About",
                                subtitle: "App version and information",
                                action: {
                                    showingAbout = true
                                }
                            )
                        }
                    }
                    
                    // App Version
                    VStack(spacing: 4) {
                        Text("NewsLocal")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("Version 1.1.1")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Bottom padding
                    Color.clear.frame(height: 50)
                }
                .padding(.horizontal, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingNotificationSettings) {
            NotificationSettingsView()
        }
        .sheet(isPresented: $showingThemeSettings) {
            ThemeSettingsView()
        }
        .sheet(isPresented: $showingPrivacySettings) {
            PrivacySettingsView()
        }
        .sheet(isPresented: $showingHelpSupport) {
            HelpSupportView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
