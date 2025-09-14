//
//  ChangePasswordView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// View for changing user password
struct ChangePasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ChangePasswordViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "key.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.blue)
                        
                        Text("Change Password")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Enter your current and new password")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Password Fields
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            SecureField("Enter current password", text: $viewModel.currentPassword)
                                .font(.body)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.secondarySystemBackground))
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("New Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            SecureField("Enter new password", text: $viewModel.newPassword)
                                .font(.body)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.secondarySystemBackground))
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm New Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            SecureField("Confirm new password", text: $viewModel.confirmPassword)
                                .font(.body)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.secondarySystemBackground))
                                )
                        }
                    }
                    
                    // Password Requirements
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password Requirements")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            PasswordRequirement(
                                text: "At least 8 characters",
                                isMet: viewModel.newPassword.count >= 8
                            )
                            
                            PasswordRequirement(
                                text: "Contains uppercase letter",
                                isMet: viewModel.hasUppercase
                            )
                            
                            PasswordRequirement(
                                text: "Contains lowercase letter",
                                isMet: viewModel.hasLowercase
                            )
                            
                            PasswordRequirement(
                                text: "Contains number",
                                isMet: viewModel.hasNumber
                            )
                            
                            PasswordRequirement(
                                text: "Passwords match",
                                isMet: viewModel.passwordsMatch
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.tertiarySystemBackground))
                    )
                    
                    // Change Password Button
                    Button(action: {
                        viewModel.changePassword()
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "key.fill")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            
                            Text(viewModel.isLoading ? "Changing..." : "Change Password")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(viewModel.canChangePassword ? Color.blue : Color.gray)
                        )
                    }
                    .disabled(!viewModel.canChangePassword || viewModel.isLoading)
                    
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
            }
        }
        .alert("Success", isPresented: $viewModel.showSuccessMessage) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your password has been changed successfully.")
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

// MARK: - Supporting Views

struct PasswordRequirement: View {
    let text: String
    let isMet: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isMet ? .green : .secondary)
            
            Text(text)
                .font(.caption)
                .foregroundColor(isMet ? .primary : .secondary)
        }
    }
}

// MARK: - ViewModel

@MainActor
class ChangePasswordViewModel: ObservableObject {
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccessMessage: Bool = false
    
    var hasUppercase: Bool {
        newPassword.rangeOfCharacter(from: .uppercaseLetters) != nil
    }
    
    var hasLowercase: Bool {
        newPassword.rangeOfCharacter(from: .lowercaseLetters) != nil
    }
    
    var hasNumber: Bool {
        newPassword.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    var passwordsMatch: Bool {
        !newPassword.isEmpty && newPassword == confirmPassword
    }
    
    var canChangePassword: Bool {
        !currentPassword.isEmpty &&
        !newPassword.isEmpty &&
        !confirmPassword.isEmpty &&
        newPassword.count >= 8 &&
        hasUppercase &&
        hasLowercase &&
        hasNumber &&
        passwordsMatch
    }
    
    func changePassword() {
        guard canChangePassword else { return }
        
        isLoading = true
        errorMessage = nil
        
        // TODO: Implement actual password change logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoading = false
            self.showSuccessMessage = true
        }
    }
}

// MARK: - Preview

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
