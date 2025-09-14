import SwiftUI

/// Modern quick actions with enhanced design and animations
struct ModernQuickActionsView: View {
    @ObservedObject var viewModel: AIChatbotViewModel
    @State private var selectedAction: String?
    
    private let quickActions = [
        QuickAction(
            title: "Today's Top News",
            icon: "📰",
            color: .blue,
            description: "Get the latest headlines"
        ),
        QuickAction(
            title: "Search News",
            icon: "🔍",
            color: .green,
            description: "Find specific topics"
        ),
        QuickAction(
            title: "News Summary",
            icon: "📊",
            color: .orange,
            description: "Quick overview"
        ),
        QuickAction(
            title: "Trending Topics",
            icon: "🌟",
            color: .purple,
            description: "What's popular now"
        ),
        QuickAction(
            title: "Weather News",
            icon: "🌤️",
            color: .cyan,
            description: "Climate updates"
        ),
        QuickAction(
            title: "Tech News",
            icon: "💻",
            color: .indigo,
            description: "Technology updates"
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Quick Actions")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Tap any action to get started")
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            // Actions grid
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(quickActions, id: \.title) { action in
                    QuickActionCard(
                        action: action,
                        isSelected: selectedAction == action.title,
                        onTap: { selectAction(action) }
                    )
                }
            }
            
            // Recent suggestions (if available)
            if !viewModel.messages.isEmpty {
                recentSuggestions
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var recentSuggestions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Topics")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(getRecentTopics(), id: \.self) { topic in
                        Button(action: { selectRecentTopic(topic) }) {
                        Text(topic)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(.blue)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.blue.opacity(0.1))
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private func selectAction(_ action: QuickAction) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            selectedAction = action.title
        }
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Send message after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            viewModel.sendMessage(action.title)
            selectedAction = nil
        }
    }
    
    private func selectRecentTopic(_ topic: String) {
        viewModel.sendMessage(topic)
    }
    
    private func getRecentTopics() -> [String] {
        // Extract recent topics from message history
        let recentMessages = viewModel.messages.prefix(10)
        let topics = recentMessages.compactMap { message -> String? in
            if message.isUser {
                let content = message.content.lowercased()
                if content.contains("news") {
                    return "Latest News"
                } else if content.contains("tech") {
                    return "Technology"
                } else if content.contains("weather") {
                    return "Weather"
                }
            }
            return nil
        }
        
        return Array(Set(topics)).prefix(5).map { String($0) }
    }
}

/// Individual quick action card
struct QuickActionCard: View {
    let action: QuickAction
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Icon
                Text(action.icon)
                    .font(.system(size: 32))
                    .scaleEffect(isSelected ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                
                // Content
                VStack(spacing: 4) {
                    Text(action.title)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(action.description)
                        .font(.system(size: 10, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .padding(12)
                    .background(backgroundView)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(isSelected ? Color(action.color).opacity(0.2) : Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? action.color.opacity(0.5) : Color.clear,
                        lineWidth: 2
                    )
            )
            .shadow(
                color: isSelected ? action.color.opacity(0.3) : .clear,
                radius: isSelected ? 8 : 0,
                x: 0,
                y: 4
            )
    }
}

/// Quick action data model
struct QuickAction {
    let title: String
    let icon: String
    let color: Color
    let description: String
}

#Preview {
    ScrollView {
        ModernQuickActionsView(viewModel: AIChatbotViewModel())
            .padding(.vertical, 20)
    }
    .background(Color(.systemGroupedBackground))
}
