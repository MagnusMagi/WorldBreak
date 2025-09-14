import Foundation
import Combine
import SwiftUI

/// ViewModel for AI Chatbot functionality
@MainActor
class AIChatbotViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isTyping = false
    @Published var errorMessage: String?
    
    private let openAIService = OpenAIService()
    private let chatHistoryManager = ChatHistoryManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupObservers()
        initializeAPIKey()
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
        
        // Check if API key is available
        let apiKeyManager = APIKeyManager()
        if apiKeyManager.hasAPIKey() {
            // Send to OpenAI
            openAIService.sendMessage(text, context: getNewsContext())
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        self?.isTyping = false
                        
                        if case .failure(let error) = completion {
                            self?.errorMessage = error.localizedDescription
                            self?.handleError(error)
                        }
                    },
                    receiveValue: { [weak self] response in
                        self?.isTyping = false
                        self?.handleAIResponse(response)
                    }
                )
                .store(in: &cancellables)
        } else {
            // Use mock response if no API key
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.isTyping = false
                self.handleAIResponse(self.generateMockResponse(for: text))
            }
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
    
    private func initializeAPIKey() {
        let apiKeyManager = APIKeyManager()
        apiKeyManager.initializeWithDefaultKey()
    }
    
    private func handleAIResponse(_ response: String) {
        let aiMessage = ChatMessage(
            id: UUID(),
            content: response,
            isUser: false,
            timestamp: Date()
        )
        
        messages.append(aiMessage)
        chatHistoryManager.saveMessage(aiMessage)
    }
    
    private func handleError(_ error: Error) {
        let errorMessage = ChatMessage(
            id: UUID(),
            content: "Üzgünüm, bir hata oluştu. Lütfen tekrar deneyin. 😔",
            isUser: false,
            timestamp: Date()
        )
        
        messages.append(errorMessage)
    }
    
    private func generateMockResponse(for userMessage: String) -> String {
        let lowercasedMessage = userMessage.lowercased()
        
        if lowercasedMessage.contains("bugün") || lowercasedMessage.contains("top news") {
            return "📰 Bugünün öne çıkan haberleri:\n\n• Teknoloji sektöründe yeni AI gelişmeleri 🚀\n• Ekonomik göstergeler olumlu seyir gösteriyor 📈\n• Uluslararası ilişkilerde önemli gelişmeler 🌍\n\nHangi konuda daha detaylı bilgi almak istersiniz?"
        } else if lowercasedMessage.contains("ara") || lowercasedMessage.contains("search") {
            return "🔍 Haber arama konusunda size yardımcı olabilirim! \n\nHangi konu veya anahtar kelime ile ilgili haberleri aramak istiyorsunuz? Size en güncel makaleleri, trend analizlerini veya özetleri bulabilirim."
        } else if lowercasedMessage.contains("özet") || lowercasedMessage.contains("summary") {
            return "📊 Güncel haber özeti:\n\n• Teknoloji sektörü güçlü büyüme gösteriyor 💻\n• Uluslararası ilişkiler istikrarlı durumda 🤝\n• Ekonomik göstergeler toparlanma işareti veriyor 💰\n\nDaha detaylı özet için hangi alanı odak almak istersiniz?"
        } else if lowercasedMessage.contains("popüler") || lowercasedMessage.contains("trending") {
            return "🌟 Şu anda popüler konular:\n\n🔥 Yapay zeka gelişmeleri\n🔥 İklim değişikliği girişimleri\n🔥 Uzay araştırmaları\n🔥 Ekonomik politika güncellemeleri\n\nHangi popüler konu hakkında detaylı bilgi almak istersiniz?"
        } else {
            return "Merhaba! 👋 NewsLocal AI asistanınızım.\n\nSize şu konularda yardımcı olabilirim:\n• 📰 Güncel haber güncellemeleri\n• 📊 Konu özetleri\n• 🔍 Trend analizleri\n• 🌟 Popüler konular\n\nHangi konuda yardıma ihtiyacınız var?"
        }
    }
    
    private func getNewsContext() -> String {
        // Get current news context for better AI responses
        return """
        Sen Türkçe konuşan bir haber asistanısın. NewsLocal uygulaması için çalışıyorsun.
        
        Görevlerin:
        - Haberler hakkında akıllı yanıtlar ver
        - Güncel olayları analiz et ve özetle
        - Kullanıcıların sorularını anla ve yardımcı ol
        - Türkçe ve İngilizce destekle
        - Kısa, net ve faydalı yanıtlar ver
        - Emoji kullanarak yanıtlarını daha çekici yap
        
        Yanıtların 2-3 paragrafı geçmesin ve her zaman yardımcı olmaya odaklan.
        """
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
