//
//  ThemeSettingsView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Complete theme and display settings view
struct ThemeSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ThemeSettingsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "paintbrush.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.purple)
                        
                        Text("Theme & Display")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Customize your app appearance")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Theme Selection
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Appearance")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            ThemeOptionRow(
                                title: "Light",
                                subtitle: "Always use light appearance",
                                icon: "sun.max.fill",
                                isSelected: viewModel.selectedTheme == .light,
                                color: .orange
                            ) {
                                viewModel.selectedTheme = .light
                            }
                            
                            ThemeOptionRow(
                                title: "Dark",
                                subtitle: "Always use dark appearance",
                                icon: "moon.fill",
                                isSelected: viewModel.selectedTheme == .dark,
                                color: .blue
                            ) {
                                viewModel.selectedTheme = .dark
                            }
                            
                            ThemeOptionRow(
                                title: "System",
                                subtitle: "Follow system appearance",
                                icon: "gear",
                                isSelected: viewModel.selectedTheme == .system,
                                color: .gray
                            ) {
                                viewModel.selectedTheme = .system
                            }
                        }
                    }
                    
                    // Font Settings
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Typography")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            SettingsToggleRow(
                                icon: "textformat.size",
                                title: "Dynamic Type",
                                subtitle: "Respect system font size settings",
                                isOn: $viewModel.dynamicType
                            )
                            
                            if !viewModel.dynamicType {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Font Size")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    HStack {
                                        Text("Small")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Slider(
                                            value: $viewModel.fontSize,
                                            in: 0...2,
                                            step: 1
                                        )
                                        .accentColor(.purple)
                                        
                                        Text("Large")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Text(viewModel.fontSizeDescription)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                )
                            }
                        }
                    }
                    
                    // Display Settings
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Display")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            SettingsToggleRow(
                                icon: "eye.fill",
                                title: "Reduce Motion",
                                subtitle: "Minimize animations and motion",
                                isOn: $viewModel.reduceMotion
                            )
                            
                            SettingsToggleRow(
                                icon: "bold",
                                title: "Bold Text",
                                subtitle: "Use bold text throughout the app",
                                isOn: $viewModel.boldText
                            )
                            
                            SettingsToggleRow(
                                icon: "contrast",
                                title: "High Contrast",
                                subtitle: "Increase contrast for better visibility",
                                isOn: $viewModel.highContrast
                            )
                        }
                    }
                    
                    // Preview Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Preview")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            PreviewCard(
                                title: "Sample Article Title",
                                subtitle: "This is how your articles will look with current settings",
                                theme: viewModel.selectedTheme
                            )
                        }
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

struct ThemeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSettingsView()
    }
}
