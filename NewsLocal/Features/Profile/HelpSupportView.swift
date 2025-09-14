//
//  HelpSupportView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Complete help and support view
struct HelpSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = HelpSupportViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)
                        
                        Text("Help & Support")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Get help and contact our support team")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Quick Help
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Help")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            HelpOptionRow(
                                title: "Frequently Asked Questions",
                                subtitle: "Find answers to common questions",
                                icon: "questionmark.circle.fill",
                                color: .blue
                            ) {
                                viewModel.openFAQ()
                            }
                            
                            HelpOptionRow(
                                title: "User Guide",
                                subtitle: "Learn how to use NewsLocal",
                                icon: "book.fill",
                                color: .green
                            ) {
                                viewModel.openUserGuide()
                            }
                            
                            HelpOptionRow(
                                title: "Troubleshooting",
                                subtitle: "Fix common issues",
                                icon: "wrench.fill",
                                color: .orange
                            ) {
                                viewModel.openTroubleshooting()
                            }
                        }
                    }
                    
                    // Contact Support
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contact Support")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            HelpOptionRow(
                                title: "Email Support",
                                subtitle: "support@newslocal.com",
                                icon: "envelope.fill",
                                color: .blue
                            ) {
                                viewModel.sendEmail()
                            }
                            
                            HelpOptionRow(
                                title: "Live Chat",
                                subtitle: "Chat with our support team",
                                icon: "message.fill",
                                color: .green
                            ) {
                                viewModel.openLiveChat()
                            }
                            
                            HelpOptionRow(
                                title: "Report a Bug",
                                subtitle: "Help us improve the app",
                                icon: "ant.fill",
                                color: .red
                            ) {
                                viewModel.reportBug()
                            }
                        }
                    }
                    
                    // Community
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Community")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            HelpOptionRow(
                                title: "User Forum",
                                subtitle: "Connect with other users",
                                icon: "person.3.fill",
                                color: .purple
                            ) {
                                viewModel.openForum()
                            }
                            
                            HelpOptionRow(
                                title: "Feature Requests",
                                subtitle: "Suggest new features",
                                icon: "lightbulb.fill",
                                color: .yellow
                            ) {
                                viewModel.openFeatureRequests()
                            }
                        }
                    }
                    
                    // App Information
                    VStack(alignment: .leading, spacing: 16) {
                        Text("App Information")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            AppInfoRow(
                                title: "Version",
                                value: "1.1.2",
                                icon: "info.circle.fill",
                                color: .blue
                            )
                            
                            AppInfoRow(
                                title: "Build",
                                value: "2024.1",
                                icon: "hammer.fill",
                                color: .gray
                            )
                            
                            AppInfoRow(
                                title: "Last Updated",
                                value: "Today",
                                icon: "clock.fill",
                                color: .green
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

struct HelpSupportView_Previews: PreviewProvider {
    static var previews: some View {
        HelpSupportView()
    }
}
