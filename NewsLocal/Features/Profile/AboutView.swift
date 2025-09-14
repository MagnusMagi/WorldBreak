//
//  AboutView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Complete about information view
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AboutViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App Icon and Title
                    VStack(spacing: 16) {
                        // App Icon
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "newspaper.fill")
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(spacing: 4) {
                            Text("NewsLocal")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Your Personal News Hub")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 20)
                    
                    // App Information
                    VStack(alignment: .leading, spacing: 16) {
                        Text("App Information")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            AboutInfoRow(
                                title: "Version",
                                value: viewModel.appVersion,
                                icon: "info.circle.fill",
                                color: .blue
                            )
                            
                            AboutInfoRow(
                                title: "Build",
                                value: viewModel.buildNumber,
                                icon: "hammer.fill",
                                color: .gray
                            )
                            
                            AboutInfoRow(
                                title: "Last Updated",
                                value: viewModel.lastUpdated,
                                icon: "clock.fill",
                                color: .green
                            )
                            
                            AboutInfoRow(
                                title: "Developer",
                                value: "Magnus Magi",
                                icon: "person.fill",
                                color: .purple
                            )
                        }
                    }
                    
                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Features")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 8) {
                            FeatureRow(
                                title: "Real-time News",
                                description: "Get the latest news as it happens",
                                icon: "bolt.fill",
                                color: .yellow
                            )
                            
                            FeatureRow(
                                title: "Personalized Feed",
                                description: "AI-powered news recommendations",
                                icon: "brain.head.profile",
                                color: .blue
                            )
                            
                            FeatureRow(
                                title: "Offline Reading",
                                description: "Read articles without internet",
                                icon: "wifi.slash",
                                color: .green
                            )
                            
                            FeatureRow(
                                title: "Dark Mode",
                                description: "Easy on the eyes in any light",
                                icon: "moon.fill",
                                color: .purple
                            )
                        }
                    }
                    
                    // Technology
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Technology")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 8) {
                            TechRow(
                                title: "SwiftUI 6.0",
                                description: "Modern iOS development",
                                icon: "swift",
                                color: .orange
                            )
                            
                            TechRow(
                                title: "Node.js 18+",
                                description: "Scalable backend API",
                                icon: "server.rack",
                                color: .green
                            )
                            
                            TechRow(
                                title: "TypeScript",
                                description: "Type-safe development",
                                icon: "textformat",
                                color: .blue
                            )
                            
                            TechRow(
                                title: "Docker",
                                description: "Containerized deployment",
                                icon: "shippingbox.fill",
                                color: .cyan
                            )
                        }
                    }
                    
                    // Legal
                    VStack(spacing: 12) {
                        Button(action: {
                            viewModel.openTermsOfService()
                        }) {
                            HStack {
                                Image(systemName: "doc.text")
                                    .foregroundColor(.blue)
                                    .frame(width: 24, height: 24)
                                
                                Text("Terms of Service")
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
                        
                        Button(action: {
                            viewModel.openPrivacyPolicy()
                        }) {
                            HStack {
                                Image(systemName: "lock.doc")
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
                    
                    // Copyright
                    VStack(spacing: 4) {
                        Text("© 2024 NewsLocal")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Made with ❤️ by Magnus Magi")
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
        .onAppear {
            viewModel.loadAppInfo()
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
