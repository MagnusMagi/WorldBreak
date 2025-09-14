import Foundation
import Combine
import SwiftUI

/// ViewModel for AI Chatbot functionality
@MainActor
class AIChatbotViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isTyping = false
    @Published var errorMessage: String?
    
    private let chatHistoryManager = ChatHistoryManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupObservers()
    }
    
    /// Send a message to the AI assistant
    func sendMessage(_ text: String) {
        let userMessage = ChatMessage(
            id: UUID(),
            content: text,
            isUser: true,
            timestamp: Date()
        )
        
        messages.append(userMessage)
        chatHistoryManager.saveMessage(userMessage)
        
        // Show typing indicator
        isTyping = true
        
        // Simulate AI response (for demo purposes)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.handleAIResponse(self.generateMockResponse(for: text))
        }
    }
    
    /// Load chat history from storage
    func loadChatHistory() {
        messages = chatHistoryManager.loadMessages()
    }
    
    /// Clear chat history
    func clearChat() {
        messages.removeAll()
        chatHistoryManager.clearHistory()
    }
    
    // MARK: - Private Methods
    
    private func setupObservers() {
        // Handle error messages
        $errorMessage
            .compactMap { $0 }
            .sink { [weak self] error in
                print("AI Chatbot Error: \(error)")
            }
            .store(in: &cancellables)
    }
    
    private func handleAIResponse(_ response: String) {
        self.isTyping = false
        
        let aiMessage = ChatMessage(
            id: UUID(),
            content: response,
            isUser: false,
            timestamp: Date()
        )
        
        messages.append(aiMessage)
        chatHistoryManager.saveMessage(aiMessage)
    }
    
    private func generateMockResponse(for userMessage: String) -> String {
        let lowercasedMessage = userMessage.lowercased()
        
        if lowercasedMessage.contains("top news") || lowercasedMessage.contains("bugün") {
            return "Here are today's top news stories:\n\n1. Breaking: Major tech company announces new AI breakthrough\n2. Economic update: Markets show positive trends\n3. Global events: International summit concludes successfully\n\nWould you like me to elaborate on any of these topics?"
        } else if lowercasedMessage.contains("search") || lowercasedMessage.contains("ara") {
            return "I can help you search for news! What specific topic or keyword would you like to search for? I can find the latest articles, analyze trends, or provide summaries on any subject."
        } else if lowercasedMessage.contains("summary") || lowercasedMessage.contains("özet") {
            return "I'd be happy to provide a news summary! Based on current events, here's what's happening:\n\n• Technology sector showing strong growth\n• International relations remain stable\n• Economic indicators point to continued recovery\n\nIs there a particular area you'd like me to focus on for a more detailed summary?"
        } else if lowercasedMessage.contains("trending") || lowercasedMessage.contains("popüler") {
            return "Current trending topics include:\n\n🔥 Artificial Intelligence developments\n🔥 Climate change initiatives\n🔥 Space exploration news\n🔥 Economic policy updates\n\nWhich trending topic interests you most? I can provide detailed information on any of these areas."
        } else {
            return "I understand you're asking about: \"\(userMessage)\"\n\nAs your AI news assistant, I can help you with:\n• Latest news updates\n• Topic summaries\n• Trend analysis\n• News search assistance\n\nHow can I assist you with news-related information today?"
        }
    }
}

/// Chat message model
struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id
    }
}

/// Chat bubble view for displaying messages
struct ChatBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 50)
                
                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                    Text(message.content)
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(.white)
                        .padding(.horizontal, DesignSystem.Spacing.md)
                        .padding(.vertical, DesignSystem.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                .fill(DesignSystem.Colors.primary)
                        )
                    
                    Text(message.timestamp.formatted(.dateTime.hour().minute()))
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
            } else {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    HStack(alignment: .top, spacing: DesignSystem.Spacing.sm) {
                        Image(systemName: "sparkles")
                            .font(.caption)
                            .foregroundColor(DesignSystem.Colors.primary)
                            .padding(.top, 2)
                        
                        Text(message.content)
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .padding(.horizontal, DesignSystem.Spacing.md)
                            .padding(.vertical, DesignSystem.Spacing.sm)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .fill(DesignSystem.Colors.backgroundSecondary)
                            )
                    }
                    
                    Text(message.timestamp.formatted(.dateTime.hour().minute()))
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .padding(.leading, DesignSystem.Spacing.lg)
                }
                
                Spacer(minLength: 50)
            }
        }
    }
}

/// Typing indicator view
struct TypingIndicatorView: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack {
            HStack(alignment: .top, spacing: DesignSystem.Spacing.sm) {
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .padding(.top, 2)
                
                HStack(spacing: 4) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(DesignSystem.Colors.primary)
                            .frame(width: 6, height: 6)
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                        .fill(DesignSystem.Colors.backgroundSecondary)
                )
            }
            
            Spacer(minLength: 50)
        }
        .onAppear {
            isAnimating = true
        }
    }
}
