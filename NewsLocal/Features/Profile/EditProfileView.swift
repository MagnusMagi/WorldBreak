//
//  EditProfileView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI
import PhotosUI

/// Complete profile editing view
struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = EditProfileViewModel()
    @State private var showingImagePicker = false
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Image Section
                    VStack(spacing: 16) {
                        Text("Profile Picture")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 12) {
                            // Profile Image
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                ZStack {
                                    AsyncImage(url: viewModel.profileImageUrl) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Circle()
                                            .fill(.blue.opacity(0.1))
                                            .overlay(
                                                Image(systemName: "person.fill")
                                                    .font(.system(size: 40, weight: .medium))
                                                    .foregroundColor(.blue)
                                            )
                                    }
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    
                                    // Edit overlay
                                    Circle()
                                        .fill(.black.opacity(0.3))
                                        .frame(width: 120, height: 120)
                                        .overlay(
                                            Image(systemName: "camera.fill")
                                                .font(.system(size: 24, weight: .medium))
                                                .foregroundColor(.white)
                                        )
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text("Tap to change photo")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Personal Information
                    VStack(spacing: 16) {
                        Text("Personal Information")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 12) {
                            EditProfileField(
                                title: "Full Name",
                                text: $viewModel.fullName,
                                placeholder: "Enter your full name"
                            )
                            
                            EditProfileField(
                                title: "Email Address",
                                text: $viewModel.email,
                                placeholder: "Enter your email",
                                keyboardType: .emailAddress
                            )
                            
                            EditProfileField(
                                title: "Bio",
                                text: $viewModel.bio,
                                placeholder: "Tell us about yourself",
                                isMultiline: true
                            )
                        }
                    }
                    
                    // Account Settings
                    VStack(spacing: 16) {
                        Text("Account Settings")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                viewModel.showChangePassword = true
                            }) {
                                HStack {
                                    Image(systemName: "key.fill")
                                        .foregroundColor(.blue)
                                        .frame(width: 24, height: 24)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Change Password")
                                            .font(.body)
                                            .fontWeight(.medium)
                                            .foregroundColor(.primary)
                                        
                                        Text("Update your account password")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                showingDeleteConfirmation = true
                            }) {
                                HStack {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.red)
                                        .frame(width: 24, height: 24)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Delete Account")
                                            .font(.body)
                                            .fontWeight(.medium)
                                            .foregroundColor(.red)
                                        
                                        Text("Permanently delete your account")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    // Bottom padding
                    Color.clear.frame(height: 50)
                }
                .padding(.horizontal, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveProfile()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!viewModel.hasChanges)
                }
            }
        }
        .photosPicker(
            isPresented: $showingImagePicker,
            selection: $viewModel.selectedPhoto,
            matching: .images
        )
        .sheet(isPresented: $viewModel.showChangePassword) {
            ChangePasswordView()
        }
        .alert("Delete Account", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteAccount()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone.")
        }
        .onAppear {
            viewModel.loadProfile()
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
