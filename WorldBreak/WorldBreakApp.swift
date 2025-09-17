//
//  WorldBreakApp.swift
//  WorldBreak
//
//  Created by Magnus Magi on 16.09.2025.
//

import SwiftUI

@main
struct WorldBreakApp: App {
    @StateObject private var userPreferences = UserPreferences()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if userPreferences.isPersonalizationCompleted {
                    NewsFeedView()
                } else {
                    LaunchScreen()
                }
            }
            .environmentObject(userPreferences)
        }
    }
}
