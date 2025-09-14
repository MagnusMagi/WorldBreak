//
//  EditProfileField.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// A custom field for editing profile information
struct EditProfileField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            if isMultiline {
                TextEditor(text: $text)
                    .font(.body)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .frame(minHeight: 80)
            } else {
                TextField(placeholder, text: $text)
                    .font(.body)
                    .keyboardType(keyboardType)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.secondarySystemBackground))
                    )
            }
        }
    }
}

// MARK: - Preview

struct EditProfileField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            EditProfileField(
                title: "Full Name",
                text: .constant("John Doe"),
                placeholder: "Enter your full name"
            )
            
            EditProfileField(
                title: "Email Address",
                text: .constant("john@example.com"),
                placeholder: "Enter your email",
                keyboardType: .emailAddress
            )
            
            EditProfileField(
                title: "Bio",
                text: .constant("Tell us about yourself"),
                placeholder: "Tell us about yourself",
                isMultiline: true
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
