import SwiftUI
import Combine

/// Modern AI Chatbot view with enhanced UI/UX
struct AIChatbotView: View {
    @StateObject private var viewModel = AIChatbotViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            // Modern Header
            modernHeader
            
            Divider()
            
            // Modern Chat Area
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Welcome message
                        if viewModel.messages.isEmpty {
                            ModernWelcomeView()
                        }
                        
                        // Chat messages with modern bubbles
                        ForEach(viewModel.messages) { message in
                            ModernChatBubbleView(message: message)
                                .id(message.id)
                        }
                        
                        // Modern typing indicator
                        if viewModel.isTyping {
                            ModernTypingIndicator()
                                .id("typing")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
                .background(
                    // Gradient background
                    LinearGradient(
                        colors: [
                            Color(.systemGroupedBackground),
                            Color(.systemGroupedBackground).opacity(0.8)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .onChange(of: viewModel.isTyping) { isTyping in
                    if isTyping {
                        // Only scroll to typing indicator when AI is typing
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                proxy.scrollTo("typing", anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            // Modern Quick Actions
            if viewModel.messages.isEmpty {
                ModernQuickActionsView(viewModel: viewModel)
                    .padding(.bottom, 20)
            }
            
            // Modern Message Input
            ModernMessageInputView(viewModel: viewModel)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadChatHistory()
        }
    }
    
    // MARK: - Standard Header (Minimal Design)
    private var modernHeader: some View {
        VStack(spacing: 0) {
            // Page Title and Navigation
            HStack {
                // Minimal back button (like categories button)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                .buttonStyle(PlainButtonStyle())
                
                Text("AI Assistant")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // AI Status indicator (minimal)
                HStack(spacing: 6) {
                    Circle()
                        .fill(viewModel.isTyping ? Color.orange : Color.green)
                        .frame(width: 6, height: 6)
                        .scaleEffect(viewModel.isTyping ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: viewModel.isTyping)
                    
                    Text(viewModel.isTyping ? "Thinking..." : "Ready")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
        }
    }
}

// MARK: - Supporting Views

/// Welcome message shown when chat is empty
struct WelcomeMessageView: View {
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundColor(DesignSystem.Colors.primary)
            
            Text("AI News Assistant")
                .font(DesignSystem.Typography.title2)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Text("Ask me anything about news, get summaries, or discover trending topics!")
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignSystem.Spacing.lg)
        }
        .padding(.vertical, DesignSystem.Spacing.xl)
    }
}

/// Quick action buttons for common queries
struct QuickActionsView: View {
    @ObservedObject var viewModel: AIChatbotViewModel
    
    private let quickActions = [
        "📰 Today's Top News",
        "🔍 Search News",
        "📊 News Summary",
        "🌟 Trending Topics"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("Quick Actions")
                .font(DesignSystem.Typography.title3)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .padding(.bottom, DesignSystem.Spacing.sm)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: DesignSystem.Spacing.sm) {
                ForEach(quickActions, id: \.self) { action in
                    Button(action: {
                        viewModel.sendMessage(action)
                    }) {
                        Text(action)
                            .font(DesignSystem.Typography.caption1)
                            .fontWeight(.medium)
                            .foregroundColor(DesignSystem.Colors.primary)
                            .padding(.horizontal, DesignSystem.Spacing.md)
                            .padding(.vertical, DesignSystem.Spacing.sm)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .fill(DesignSystem.Colors.backgroundSecondary)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                            .stroke(DesignSystem.Colors.primary.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

/// Message input field with send button
struct MessageInputView: View {
    @ObservedObject var viewModel: AIChatbotViewModel
    @State private var messageText = ""
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            TextField("Ask me anything about news...", text: $messageText)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.full)
                        .fill(DesignSystem.Colors.backgroundSecondary)
                )
                .onSubmit {
                    sendMessage()
                }
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .font(.title3)
                    .foregroundColor(messageText.isEmpty ? DesignSystem.Colors.textSecondary : DesignSystem.Colors.primary)
            }
            .disabled(messageText.isEmpty || viewModel.isTyping)
        }
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let message = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        messageText = ""
        viewModel.sendMessage(message)
    }
}

// MARK: - Preview

struct AIChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        AIChatbotView()
    }
}
