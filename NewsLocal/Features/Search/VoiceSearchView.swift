//
//  VoiceSearchView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI
import AVFoundation
import Speech

/// View for voice search functionality
struct VoiceSearchView: View {
    @Binding var isPresented: Bool
    let onSearchResult: (String) -> Void
    
    @StateObject private var voiceManager = VoiceSearchManager()
    @State private var isRecording = false
    @State private var transcribedText = ""
    @State private var showingPermissionAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: DesignSystem.Spacing.xl) {
                // Voice Visualizer
                VoiceVisualizer(isRecording: isRecording)
                
                // Status Text
                VStack(spacing: DesignSystem.Spacing.md) {
                    Text(voiceManager.statusText)
                        .font(DesignSystem.Typography.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    if !transcribedText.isEmpty {
                        Text(transcribedText)
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                    }
                }
                
                // Recording Button
                VoiceSearchButton(
                    isRecording: isRecording,
                    onTap: {
                        if isRecording {
                            stopRecording()
                        } else {
                            startRecording()
                        }
                    }
                )
                
                // Action Buttons
                HStack(spacing: DesignSystem.Spacing.lg) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .secondaryButtonStyle()
                    
                    if !transcribedText.isEmpty {
                        Button("Search") {
                            onSearchResult(transcribedText)
                            isPresented = false
                        }
                        .primaryButtonStyle()
                    }
                }
            }
            .padding(DesignSystem.Spacing.xl)
            .navigationTitle("Voice Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
        .onAppear {
            checkPermissions()
        }
        .alert("Permission Required", isPresented: $showingPermissionAlert) {
            Button("Settings") {
                openAppSettings()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Voice search requires microphone and speech recognition permissions. Please enable them in Settings.")
        }
        .onReceive(voiceManager.$transcribedText) { text in
            transcribedText = text
        }
    }
    
    // MARK: - Private Methods
    
    private func startRecording() {
        voiceManager.startRecording { result in
            switch result {
            case .success:
                isRecording = true
            case .failure(let error):
                print("Recording failed: \(error)")
            }
        }
    }
    
    private func stopRecording() {
        voiceManager.stopRecording()
        isRecording = false
    }
    
    private func checkPermissions() {
        voiceManager.checkPermissions { hasPermission in
            if !hasPermission {
                showingPermissionAlert = true
            }
        }
    }
    
    private func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

// MARK: - Voice Visualizer

struct VoiceVisualizer: View {
    let isRecording: Bool
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            ForEach(0..<5, id: \.self) { index in
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                    .fill(DesignSystem.Colors.primary)
                    .frame(width: 4, height: isRecording ? CGFloat.random(in: 20...60) : 20)
                    .animation(
                        isRecording ? 
                        .easeInOut(duration: 0.5).repeatForever(autoreverses: true) :
                        .easeInOut(duration: 0.3),
                        value: isRecording
                    )
                    .animation(.easeInOut(duration: 0.3).delay(Double(index) * 0.1), value: animationOffset)
            }
        }
        .frame(height: 60)
        .onAppear {
            animationOffset = 1
        }
    }
}

// MARK: - Voice Search Button

struct VoiceSearchButton: View {
    let isRecording: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(isRecording ? DesignSystem.Colors.error : DesignSystem.Colors.primary)
                    .frame(width: 120, height: 120)
                    .scaleEffect(isRecording ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: isRecording)
                
                Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

struct VoiceSearchView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceSearchView(
            isPresented: .constant(true),
            onSearchResult: { _ in }
        )
    }
}
