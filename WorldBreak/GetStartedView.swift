//
//  GetStartedView.swift
//  WorldBreak
//
//  Created by Magnus Magi on 16.09.2025.
//

import SwiftUI

struct GetStartedView: View {
    @State private var showOnboarding = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color.gray.opacity(0.05), Color.blue.opacity(0.02)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Hero Section
                VStack(spacing: 20) {
                    Image(systemName: "globe.americas.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.blue)
                    
                    Text("Welcome to WorldBreak")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                    
                    Text("Your gateway to discovering amazing places around the world. Plan your next adventure with us!")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Features Preview
                VStack(spacing: 16) {
                    FeatureRow(icon: "map.fill", title: "Discover Places", description: "Find hidden gems worldwide")
                    FeatureRow(icon: "heart.fill", title: "Save Favorites", description: "Keep track of places you love")
                    FeatureRow(icon: "person.2.fill", title: "Share with Friends", description: "Plan trips together")
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Get Started Button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showOnboarding = true
                    }
                }) {
                    HStack {
                        Text("Get Started")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView()
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    GetStartedView()
}
