//
//  ContentView.swift
//  WorldBreak
//
//  Created by Magnus Magi on 16.09.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Welcome Header
                VStack(spacing: 16) {
                    Image(systemName: "globe.americas.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Welcome to WorldBreak!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                    
                    Text("You're all set to start exploring the world")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                
                Spacer()
                
                // Quick Actions
                VStack(spacing: 16) {
                    ActionButton(
                        title: "Explore Places",
                        icon: "map.fill",
                        color: .blue
                    )
                    
                    ActionButton(
                        title: "My Favorites",
                        icon: "heart.fill",
                        color: .red
                    )
                    
                    ActionButton(
                        title: "Plan Trip",
                        icon: "calendar.badge.plus",
                        color: .green
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationTitle("WorldBreak")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


#Preview {
    ContentView()
}
