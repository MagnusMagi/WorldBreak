//
//  AboutViewModel.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import SwiftUI

/// ViewModel for about information
@MainActor
class AboutViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var appVersion: String = "1.1.2"
    @Published var buildNumber: String = "2024.1"
    @Published var lastUpdated: String = "Today"
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Public Methods
    
    /// Load app information
    func loadAppInfo() {
        // Get version from Bundle
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            buildNumber = build
        }
        
        // TODO: Get last updated date from app store or server
        lastUpdated = "Today"
    }
    
    /// Open terms of service
    func openTermsOfService() {
        // TODO: Open terms of service URL
        if let url = URL(string: "https://newslocal.com/terms") {
            UIApplication.shared.open(url)
        }
    }
    
    /// Open privacy policy
    func openPrivacyPolicy() {
        // TODO: Open privacy policy URL
        if let url = URL(string: "https://newslocal.com/privacy") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Extensions

extension AboutViewModel {
    /// Mock data for previews
    static let mock = AboutViewModel()
}
