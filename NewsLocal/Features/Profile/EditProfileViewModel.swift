//
//  EditProfileViewModel.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import SwiftUI
import PhotosUI

/// ViewModel for editing user profile
@MainActor
class EditProfileViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var bio: String = ""
    @Published var profileImageUrl: URL?
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var showChangePassword: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccessMessage: Bool = false
    
    // MARK: - Private Properties
    
    private var originalProfile: User?
    
    // MARK: - Computed Properties
    
    var hasChanges: Bool {
        guard let original = originalProfile else { return false }
        
        return fullName != original.name ||
               email != original.email ||
               bio != (original.preferences.bio ?? "") ||
               profileImageUrl != original.profileImageUrl
    }
    
    // MARK: - Public Methods
    
    /// Load current profile data
    func loadProfile() {
        // For now, use mock data
        // TODO: Replace with actual user service
        let mockUser = User.mock
        originalProfile = mockUser
        
        fullName = mockUser.name
        email = mockUser.email
        bio = mockUser.preferences.bio ?? ""
        profileImageUrl = mockUser.profileImageUrl
    }
    
    /// Save profile changes
    func saveProfile() {
        guard hasChanges else { return }
        
        isLoading = true
        errorMessage = nil
        
        // TODO: Implement actual save logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.showSuccessMessage = true
            
            // Update original profile
            self.originalProfile = User(
                id: self.originalProfile?.id ?? UUID().uuidString,
                email: self.email,
                name: self.fullName,
                profileImageUrl: self.profileImageUrl,
                preferences: UserPreferences(
                    bio: self.bio.isEmpty ? nil : self.bio
                )
            )
        }
    }
    
    /// Delete user account
    func deleteAccount() {
        isLoading = true
        errorMessage = nil
        
        // TODO: Implement actual account deletion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.showSuccessMessage = true
        }
    }
    
    /// Process selected photo
    func processSelectedPhoto() {
        guard let selectedPhoto = selectedPhoto else { return }
        
        selectedPhoto.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    // TODO: Upload image to server and get URL
                    // For now, just update the local URL
                    DispatchQueue.main.async {
                        // Simulate image upload
                        self.profileImageUrl = URL(string: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load image: \(error.localizedDescription)"
                }
            }
        }
    }
    
    /// Validate email format
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Validate form
    func validateForm() -> Bool {
        return !fullName.isEmpty &&
               !email.isEmpty &&
               validateEmail() &&
               !bio.isEmpty
    }
}

// MARK: - Extensions

extension EditProfileViewModel {
    /// Mock data for previews
    static let mock = EditProfileViewModel()
}
