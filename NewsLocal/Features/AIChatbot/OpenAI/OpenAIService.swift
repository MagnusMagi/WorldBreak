import Foundation
import Combine

/// Service for interacting with OpenAI GPT-3.5-turbo API
class OpenAIService: ObservableObject {
    private let apiKeyManager = APIKeyManager()
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    /// Send a message to GPT-4o and get response
    func sendMessage(_ message: String, context: String? = nil) -> AnyPublisher<String, Error> {
        guard let apiKey = apiKeyManager.getAPIKey() else {
            return Fail(error: OpenAIError.missingAPIKey)
                .eraseToAnyPublisher()
        }
        
        let request = createChatRequest(message: message, context: context, apiKey: apiKey)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: OpenAIResponse.self, decoder: JSONDecoder())
            .map { response in
                response.choices.first?.message.content ?? "No response received"
            }
            .mapError { error in
                if error is DecodingError {
                    return OpenAIError.invalidResponse
                } else {
                    return error
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    
    private func createChatRequest(message: String, context: String?, apiKey: String) -> URLRequest {
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let systemMessage = context ?? """
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
        
        let requestBody = OpenAIRequest(
            model: "gpt-3.5-turbo",
            messages: [
                OpenAIMessage(role: "system", content: systemMessage),
                OpenAIMessage(role: "user", content: message)
            ],
            maxTokens: 300,
            temperature: 0.7
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            print("Error encoding request: \(error)")
        }
        
        return request
    }
}

// MARK: - Data Models

struct OpenAIRequest: Codable {
    let model: String
    let messages: [OpenAIMessage]
    let maxTokens: Int
    let temperature: Double
    
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature
        case maxTokens = "max_tokens"
    }
}

struct OpenAIMessage: Codable {
    let role: String
    let content: String
}

struct OpenAIResponse: Codable {
    let choices: [OpenAIChoice]
}

struct OpenAIChoice: Codable {
    let message: OpenAIMessage
}

// MARK: - Error Types

enum OpenAIError: LocalizedError {
    case missingAPIKey
    case invalidResponse
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "API anahtarı bulunamadı"
        case .invalidResponse:
            return "Geçersiz yanıt alındı"
        case .networkError:
            return "Ağ hatası oluştu"
        }
    }
}
