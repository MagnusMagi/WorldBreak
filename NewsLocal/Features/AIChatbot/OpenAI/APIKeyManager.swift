import Foundation
import Security

/// Manages OpenAI API key securely using Keychain
class APIKeyManager {
    private let keychainService = "com.noord7.NewsLocal"
    private let keychainAccount = "OpenAI_API_Key"
    
    /// Get API key from Keychain
    func getAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
           let data = result as? Data,
           let apiKey = String(data: data, encoding: .utf8) {
            return apiKey
        }
        
        return nil
    }
    
    /// Save API key to Keychain
    func saveAPIKey(_ apiKey: String) -> Bool {
        // First, delete existing key
        deleteAPIKey()
        
        let data = apiKey.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Delete API key from Keychain
    func deleteAPIKey() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    /// Check if API key exists
    func hasAPIKey() -> Bool {
        return getAPIKey() != nil
    }
    
    /// Initialize with default API key (for development)
    func initializeWithDefaultKey() {
        // API key will be set by the user through settings
        // For security reasons, we don't store it in the code
        print("API key initialization - please set your OpenAI API key in settings")
    }
}
