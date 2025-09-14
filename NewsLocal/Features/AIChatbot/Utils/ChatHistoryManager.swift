import Foundation

/// Manages chat history persistence
class ChatHistoryManager {
    private let userDefaults = UserDefaults.standard
    private let chatHistoryKey = "AIChatbot_ChatHistory"
    private let maxHistoryCount = 100
    
    /// Save a message to chat history
    func saveMessage(_ message: ChatMessage) {
        var messages = loadMessages()
        messages.append(message)
        
        // Limit history size
        if messages.count > maxHistoryCount {
            messages = Array(messages.suffix(maxHistoryCount))
        }
        
        saveMessages(messages)
    }
    
    /// Load all messages from storage
    func loadMessages() -> [ChatMessage] {
        guard let data = userDefaults.data(forKey: chatHistoryKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([ChatMessage].self, from: data)
        } catch {
            print("Error loading chat history: \(error)")
            return []
        }
    }
    
    /// Save messages to storage
    private func saveMessages(_ messages: [ChatMessage]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(messages)
            userDefaults.set(data, forKey: chatHistoryKey)
        } catch {
            print("Error saving chat history: \(error)")
        }
    }
    
    /// Clear all chat history
    func clearHistory() {
        userDefaults.removeObject(forKey: chatHistoryKey)
    }
    
    /// Get message count
    func getMessageCount() -> Int {
        return loadMessages().count
    }
}

// MARK: - ChatMessage Codable Extension

extension ChatMessage: Codable {
    enum CodingKeys: String, CodingKey {
        case id, content, isUser, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        isUser = try container.decode(Bool.self, forKey: .isUser)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(content, forKey: .content)
        try container.encode(isUser, forKey: .isUser)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
