import SwiftUI

/// Modern message input with enhanced features
struct ModernMessageInputView: View {
    @ObservedObject var viewModel: AIChatbotViewModel
    @State private var messageText = ""
    @State private var isExpanded = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Quick suggestion chips (when typing)
            if !messageText.isEmpty && !isExpanded {
                quickSuggestions
            }
            
            // Main input area
            HStack(spacing: 12) {
                // Text input field
                HStack(spacing: 8) {
                    TextField("Ask me anything about news...", text: $messageText, axis: .vertical)
                        .font(.system(.body, design: .rounded))
                        .lineLimit(isExpanded ? 3 : 1)
                        .focused($isTextFieldFocused)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isExpanded = true
                            }
                        }
                        .onSubmit {
                            sendMessage()
                        }
                    
                    // Send button
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(canSendMessage ? .blue : .gray)
                    }
                    .disabled(!canSendMessage)
                    .scaleEffect(canSendMessage ? 1.0 : 0.9)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: canSendMessage)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    isTextFieldFocused ? Color.blue.opacity(0.5) : Color.clear,
                                    lineWidth: 2
                                )
                        )
                )
                .animation(.easeInOut(duration: 0.2), value: isTextFieldFocused)
            }
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        )
    }
    
    private var quickSuggestions: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(getQuickSuggestions(), id: \.self) { suggestion in
                    Button(action: { selectSuggestion(suggestion) }) {
                        Text(suggestion)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.1))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
        }
        .transition(.asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        ))
    }
    
    
    private var canSendMessage: Bool {
        !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !viewModel.isTyping
    }
    
    private func getQuickSuggestions() -> [String] {
        let suggestions = [
            "More details",
            "Explain further",
            "Related news",
            "Recent updates"
        ]
        
        // Return random suggestions based on context
        return Array(suggestions.shuffled().prefix(3))
    }
    
    private func selectSuggestion(_ suggestion: String) {
        messageText = suggestion
        sendMessage()
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let message = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        messageText = ""
        isExpanded = false
        isTextFieldFocused = false
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        viewModel.sendMessage(message)
    }
    
}

#Preview {
    VStack {
        Spacer()
        
        ModernMessageInputView(viewModel: AIChatbotViewModel())
            .environment(\.colorScheme, .light)
    }
    .background(Color(.systemGroupedBackground))
}
