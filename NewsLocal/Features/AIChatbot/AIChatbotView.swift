import SwiftUI
import Combine

/// AI Chatbot view for intelligent news assistance
struct AIChatbotView: View {
    @StateObject private var viewModel = AIChatbotViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                        Text("Back")
                            .font(.headline)
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                }
                
                Spacer()
                
                Text("AI Assistant")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Placeholder for symmetry
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                    Text("Back")
                        .font(.headline)
                }
                .opacity(0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            
            Divider()
            
            // Chat messages area
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: DesignSystem.Spacing.md) {
                        // Welcome message
                        if viewModel.messages.isEmpty {
                            WelcomeMessageView()
                        }
                        
                        // Chat messages
                        ForEach(viewModel.messages) { message in
                            ChatBubbleView(message: message)
                                .id(message.id)
                        }
                        
                        // Typing indicator
                        if viewModel.isTyping {
                            TypingIndicatorView()
                                .id("typing")
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.md)
                    .padding(.vertical, DesignSystem.Spacing.sm)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if let lastMessage = viewModel.messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: viewModel.isTyping) { isTyping in
                    if isTyping {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo("typing", anchor: .bottom)
                        }
                    }
                }
            }
            
            // Quick actions (when no messages)
            if viewModel.messages.isEmpty {
                QuickActionsView(viewModel: viewModel)
                    .padding(.horizontal, DesignSystem.Spacing.md)
                    .padding(.bottom, DesignSystem.Spacing.lg)
            }
            
            // Message input area
            MessageInputView(viewModel: viewModel)
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.bottom, DesignSystem.Spacing.sm)
                .background(Color(.systemBackground))
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadChatHistory()
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
