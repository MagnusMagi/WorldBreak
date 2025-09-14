//
//  ImageSearchView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI
import PhotosUI
import Vision

/// View for image search functionality
struct ImageSearchView: View {
    @Binding var isPresented: Bool
    let onSearchResult: (String) -> Void
    
    @StateObject private var imageManager = ImageSearchManager()
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var isProcessing = false
    @State private var detectedText = ""
    @State private var showingPermissionAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: DesignSystem.Spacing.xl) {
                // Image Display
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 300)
                        .cornerRadius(DesignSystem.CornerRadius.lg)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                                .stroke(DesignSystem.Colors.border, lineWidth: 1)
                        )
                } else {
                    // Placeholder
                    VStack(spacing: DesignSystem.Spacing.md) {
                        Image(systemName: "photo")
                            .font(.system(size: 48))
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                        
                        Text("Select an image to search")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .background(DesignSystem.Colors.backgroundSecondary)
                    .cornerRadius(DesignSystem.CornerRadius.lg)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                            .stroke(DesignSystem.Colors.border, lineWidth: 1)
                    )
                }
                
                // Detected Text
                if !detectedText.isEmpty {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("Detected Text:")
                            .font(DesignSystem.Typography.caption1)
                            .fontWeight(.medium)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .textCase(.uppercase)
                        
                        Text(detectedText)
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.backgroundSecondary)
                            .cornerRadius(DesignSystem.CornerRadius.md)
                    }
                }
                
                // Action Buttons
                VStack(spacing: DesignSystem.Spacing.md) {
                    HStack(spacing: DesignSystem.Spacing.md) {
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            HStack(spacing: DesignSystem.Spacing.sm) {
                                Image(systemName: "photo.on.rectangle")
                                Text("Photo Library")
                            }
                        }
                        .secondaryButtonStyle()
                        
                        Button(action: {
                            showingCamera = true
                        }) {
                            HStack(spacing: DesignSystem.Spacing.sm) {
                                Image(systemName: "camera")
                                Text("Camera")
                            }
                        }
                        .secondaryButtonStyle()
                    }
                    
                    if selectedImage != nil {
                        HStack(spacing: DesignSystem.Spacing.md) {
                            Button("Clear") {
                                clearImage()
                            }
                            .secondaryButtonStyle()
                            
                            Button(action: {
                                if !detectedText.isEmpty {
                                    onSearchResult(detectedText)
                                    isPresented = false
                                }
                            }) {
                                HStack(spacing: DesignSystem.Spacing.sm) {
                                    if isProcessing {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                    } else {
                                        Image(systemName: "magnifyingglass")
                                    }
                                    Text("Search")
                                }
                            }
                            .primaryButtonStyle()
                            .disabled(isProcessing || detectedText.isEmpty)
                        }
                    }
                }
                
                // Processing Indicator
                if isProcessing {
                    HStack(spacing: DesignSystem.Spacing.sm) {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Processing image...")
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                }
            }
            .padding(DesignSystem.Spacing.xl)
            .navigationTitle("Image Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .sheet(isPresented: $showingCamera) {
            CameraView(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { image in
            if let image = image {
                processImage(image)
            }
        }
        .alert("Permission Required", isPresented: $showingPermissionAlert) {
            Button("Settings") {
                openAppSettings()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Camera access is required to take photos for image search.")
        }
    }
    
    // MARK: - Private Methods
    
    private func processImage(_ image: UIImage) {
        isProcessing = true
        detectedText = ""
        
        imageManager.extractText(from: image) { result in
            DispatchQueue.main.async {
                isProcessing = false
                
                switch result {
                case .success(let text):
                    detectedText = text
                case .failure(let error):
                    detectedText = "Failed to extract text: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func clearImage() {
        selectedImage = nil
        detectedText = ""
        isProcessing = false
    }
    
    private func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

// MARK: - Image Picker

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}

// MARK: - Camera View

struct CameraView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.cameraDevice = .rear
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// MARK: - Preview

struct ImageSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSearchView(
            isPresented: .constant(true),
            onSearchResult: { _ in }
        )
    }
}
