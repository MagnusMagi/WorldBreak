//
//  OnboardingView.swift
//  WorldBreak
//
//  Created by Magnus Magi on 16.09.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainApp = false
    
    private let onboardingPages = [
        OnboardingPage(
            title: "Explore the World",
            description: "Discover amazing destinations and hidden gems from around the globe",
            image: "map.fill",
            color: .blue
        ),
        OnboardingPage(
            title: "Plan Your Journey",
            description: "Create detailed itineraries and organize your travel plans effortlessly",
            image: "calendar.badge.plus",
            color: .green
        ),
        OnboardingPage(
            title: "Share & Connect",
            description: "Share your experiences with friends and discover new places together",
            image: "person.2.fill",
            color: .orange
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [onboardingPages[currentPage].color.opacity(0.03), Color.gray.opacity(0.02)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Skip Button
                HStack {
                    Spacer()
                    Button("Skip") {
                        showMainApp = true
                    }
                    .foregroundColor(.secondary)
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                }
                
                // Page Content
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Bottom Section
                VStack(spacing: 8) {
                    // Page Indicator
                    HStack(spacing: 8) {
                        ForEach(0..<onboardingPages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? onboardingPages[currentPage].color : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Action Buttons
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            Button("Previous") {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage -= 1
                                }
                            }
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        
                        Button(currentPage == onboardingPages.count - 1 ? "Get Started" : "Next") {
                            if currentPage == onboardingPages.count - 1 {
                                showMainApp = true
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage += 1
                                }
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [onboardingPages[currentPage].color, onboardingPages[currentPage].color.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            CategorySelectionView()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let image: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Image
            Image(systemName: page.image)
                .font(.system(size: 120))
                .foregroundColor(page.color)
                .padding(.bottom, 20)
            
            // Text Content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)
                    .lineLimit(2)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
