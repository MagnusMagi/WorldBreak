import SwiftUI

/// Chat settings and preferences view
struct ChatSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var apiKey = ""
    @State private var showAPIKeyField = false
    @State private var selectedTheme = "Auto"
    @State private var enableHaptics = true
    @State private var enableSoundEffects = true
    @State private var autoScroll = true
    
    private let themes = ["Auto", "Light", "Dark"]
    
    var body: some View {
        NavigationView {
            List {
                // API Configuration Section
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("OpenAI API Key")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("Configure your OpenAI API key for enhanced AI responses")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(showAPIKeyField ? "Hide" : "Configure") {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showAPIKeyField.toggle()
                                }
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                        
                        if showAPIKeyField {
                            SecureField("Enter your OpenAI API key", text: $apiKey)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(.body, design: .monospaced))
                                .transition(.asymmetric(
                                    insertion: .scale.combined(with: .opacity),
                                    removal: .scale.combined(with: .opacity)
                                ))
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("AI Configuration")
                }
                
                // Appearance Section
                Section {
                    // Theme Selection
                    HStack {
                        Image(systemName: "paintbrush.fill")
                            .foregroundColor(.purple)
                            .frame(width: 24)
                        
                        Text("Theme")
                            .font(.headline)
                        
                        Spacer()
                        
                        Picker("Theme", selection: $selectedTheme) {
                            ForEach(themes, id: \.self) { theme in
                                Text(theme).tag(theme)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    // Haptic Feedback
                    HStack {
                        Image(systemName: "iphone.radiowaves.left.and.right")
                            .foregroundColor(.orange)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Haptic Feedback")
                                .font(.headline)
                            Text("Vibration feedback for interactions")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $enableHaptics)
                    }
                    
                    // Sound Effects
                    HStack {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(.green)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Sound Effects")
                                .font(.headline)
                            Text("Audio feedback for actions")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $enableSoundEffects)
                    }
                } header: {
                    Text("Appearance & Feedback")
                }
                
                // Chat Behavior Section
                Section {
                    // Auto Scroll
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.cyan)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Auto Scroll")
                                .font(.headline)
                            Text("Automatically scroll to new messages")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $autoScroll)
                    }
                } header: {
                    Text("Chat Behavior")
                }
                
                // Data Management Section
                Section {
                    Button(action: clearChatHistory) {
                        HStack {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                                .frame(width: 24)
                            
                            Text("Clear Chat History")
                                .font(.headline)
                                .foregroundColor(.red)
                            
                            Spacer()
                        }
                    }
                    
                    Button(action: exportChatHistory) {
                        HStack {
                            Image(systemName: "square.and.arrow.up.fill")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            
                            Text("Export Chat History")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Spacer()
                        }
                    }
                } header: {
                    Text("Data Management")
                }
                
                // About Section
                Section {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("AI News Assistant")
                                .font(.headline)
                            Text("Version 1.0.0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func clearChatHistory() {
        // TODO: Implement clear chat history
        print("Clearing chat history...")
    }
    
    private func exportChatHistory() {
        // TODO: Implement export chat history
        print("Exporting chat history...")
    }
}

#Preview {
    ChatSettingsView()
}
