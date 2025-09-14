//
//  HelpSupportViewModel.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import SwiftUI

/// ViewModel for help and support functionality
@MainActor
class HelpSupportViewModel: ObservableObject {
    
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
    
    /// Open FAQ
    func openFAQ() {
        // TODO: Open FAQ URL
        if let url = URL(string: "https://newslocal.com/faq") {
            UIApplication.shared.open(url)
        }
    }
    
    /// Open user guide
    func openUserGuide() {
        // TODO: Open user guide URL
        if let url = URL(string: "https://newslocal.com/guide") {
            UIApplication.shared.open(url)
        }
    }
    
    /// Open troubleshooting
    func openTroubleshooting() {
        // TODO: Open troubleshooting URL
        if let url = URL(string: "https://newslocal.com/troubleshooting") {
            UIApplication.shared.open(url)
        }
    }
    
    /// Send email to support
    func sendEmail() {
        let email = "support@newslocal.com"
        let subject = "NewsLocal Support Request"
        let body = "Please describe your issue or question here..."
        
        if let url = URL(string: "mailto:\(email)?subject=\(subject)&body=\(body)") {
            UIApplication.shared.open(url)
        }
    }
    
    /// Open live chat
    func openLiveChat() {
        // TODO: Open live chat interface
        print("Opening live chat...")
    }
    
    /// Report a bug
    func reportBug() {
        let email = "bugs@newslocal.com"
        let subject = "Bug Report - NewsLocal \(appVersion)"
        let body = """
        Please describe the bug you encountered:
        
        Steps to reproduce:
        1. 
        2. 
        3. 
        
        Expected behavior:
        
        Actual behavior:
        
        Device: \(UIDevice.current.model)
        iOS Version: \(UIDevice.current.systemVersion)
        App Version: \(appVersion)
        """
        
        if let url = URL(string: "mailto:\(email)?subject=\(subject)&body=\(body)") {
            UIApplication.shared.open(url)
        }
    }
    
    /// Open user forum
    func openForum() {
        // TODO: Open forum URL
        if let url = URL(string: "https://forum.newslocal.com") {
            UIApplication.shared.open(url)
        }
    }
    
    /// Open feature requests
    func openFeatureRequests() {
        // TODO: Open feature requests URL
        if let url = URL(string: "https://newslocal.com/features") {
            UIApplication.shared.open(url)
        }
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

extension HelpSupportViewModel {
    /// Mock data for previews
    static let mock = HelpSupportViewModel()
}
