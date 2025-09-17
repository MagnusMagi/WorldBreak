//
//  LaunchScreen.swift
//  WorldBreak
//
//  Created by Magnus Magi on 16.09.2025.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            GetStartedView()
        } else {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.gray.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // App Icon
                    Image(systemName: "globe.americas.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.primary)
                        .scaleEffect(size)
                        .opacity(opacity)
                    
                    // App Name
                    Text("WorldBreak")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .scaleEffect(size)
                        .opacity(opacity)
                    
                    // Tagline
                    Text("Discover the world, one break at a time")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .scaleEffect(size)
                        .opacity(opacity)
                }
                .padding(.horizontal, 20)
            }
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 0.9
                    self.opacity = 1.0
                }
                
                // 3 saniye sonra GetStartedView'a geç
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
