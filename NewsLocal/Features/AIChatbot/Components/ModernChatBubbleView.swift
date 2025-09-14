import SwiftUI

/// Modern chat bubble with enhanced visual design and animations
struct ModernChatBubbleView: View {
    let message: ChatMessage
    @State private var isAppeared = false
    @State private var showActions = false
    @State private var isLiked = false
    @State private var isFavorited = false
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(alignment: .top, spacing: 12) {
                if !message.isUser {
                    // AI Avatar
                    AIAvatarView(isTyping: false)
                }
                
                VStack(alignment: message.isUser ? .trailing : .leading, spacing: 8) {
                    // Message bubble
                    messageBubble
                    
                    // Message actions
                    if showActions && !message.isUser {
                        messageActions
                    }
                }
                
                if message.isUser {
                    // User avatar
                    UserAvatarView()
                }
            }
            
            // Timestamp aligned under avatar
            HStack {
                if !message.isUser {
                    // AI message - timestamp under AI avatar
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer().frame(width: 32) // Match avatar width
                        Text(message.timestamp.formatted(.dateTime.hour().minute()))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                } else {
                    // User message - timestamp under user avatar
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(message.timestamp.formatted(.dateTime.hour().minute()))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer().frame(width: 32) // Match avatar width
                    }
                }
            }
        }
        .scaleEffect(isAppeared ? 1.0 : 0.8)
        .opacity(isAppeared ? 1.0 : 0.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isAppeared)
        .onAppear {
            isAppeared = true
        }
        .onTapGesture {
            if !message.isUser {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showActions.toggle()
                }
            }
        }
    }
    
    private var messageBubble: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 60)
            }
            
            Text(message.content)
                .font(.system(.body, design: .rounded))
                .foregroundColor(message.isUser ? .white : .primary)
                .multilineTextAlignment(message.isUser ? .trailing : .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(message.isUser ? userBubbleGradient : aiBubbleGradient)
                )
            
            if !message.isUser {
                Spacer(minLength: 60)
            }
        }
    }
    
    private var messageActions: some View {
        HStack(spacing: 16) {
            Button(action: { toggleLike() }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(isLiked ? .red : .secondary)
                    .font(.caption)
            }
            
            Button(action: { toggleFavorite() }) {
                Image(systemName: isFavorited ? "star.fill" : "star")
                    .foregroundColor(isFavorited ? .yellow : .secondary)
                    .font(.caption)
            }
            
            Button(action: { copyMessage() }) {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            
            Button(action: { shareMessage() }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .transition(.asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        ))
    }
    
    private var userBubbleGradient: LinearGradient {
        LinearGradient(
            colors: [Color.blue, Color.purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var aiBubbleGradient: LinearGradient {
        LinearGradient(
            colors: [Color(.systemGray6), Color(.systemGray5)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private func toggleLike() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            isLiked.toggle()
        }
    }
    
    private func toggleFavorite() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            isFavorited.toggle()
        }
    }
    
    private func copyMessage() {
        UIPasteboard.general.string = message.content
        // Show toast notification
    }
    
    private func shareMessage() {
        let activityVC = UIActivityViewController(
            activityItems: [message.content],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

/// AI Avatar with animated sparkles
struct AIAvatarView: View {
    let isTyping: Bool
    @State private var sparkleRotation = 0.0
    @State private var pulseScale = 1.0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.purple, Color.blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 32, height: 32)
                .scaleEffect(pulseScale)
                .animation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: pulseScale
                )
            
            Image(systemName: "sparkles")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .rotationEffect(.degrees(sparkleRotation))
                .animation(
                    .linear(duration: 3).repeatForever(autoreverses: false),
                    value: sparkleRotation
                )
        }
        .onAppear {
            sparkleRotation = 360
            pulseScale = isTyping ? 1.2 : 1.0
        }
        .onChange(of: isTyping) { typing in
            withAnimation(.easeInOut(duration: 0.3)) {
                pulseScale = typing ? 1.2 : 1.0
            }
        }
    }
}

/// User Avatar
struct UserAvatarView: View {
    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [Color.green, Color.blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 32, height: 32)
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            )
    }
}

#Preview {
    VStack(spacing: 16) {
        ModernChatBubbleView(message: ChatMessage(
            id: UUID(),
            content: "Hello! How can I help you with news today?",
            isUser: false,
            timestamp: Date()
        ))
        
        ModernChatBubbleView(message: ChatMessage(
            id: UUID(),
            content: "Tell me about the latest technology news",
            isUser: true,
            timestamp: Date()
        ))
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
