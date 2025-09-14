import SwiftUI

/// Modern typing indicator with advanced animations
struct ModernTypingIndicator: View {
    @State private var dot1Scale = 1.0
    @State private var dot2Scale = 1.0
    @State private var dot3Scale = 1.0
    @State private var dot1Opacity = 0.5
    @State private var dot2Opacity = 0.5
    @State private var dot3Opacity = 0.5
    @State private var sparkleRotation = 0.0
    @State private var pulseScale = 1.0
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // AI Avatar with typing animation
            AIAvatarView(isTyping: true)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    // Typing dots
                    HStack(spacing: 6) {
                        TypingDot(
                            scale: $dot1Scale,
                            opacity: $dot1Opacity,
                            delay: 0.0
                        )
                        
                        TypingDot(
                            scale: $dot2Scale,
                            opacity: $dot2Opacity,
                            delay: 0.2
                        )
                        
                        TypingDot(
                            scale: $dot3Scale,
                            opacity: $dot3Opacity,
                            delay: 0.4
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [Color(.systemGray6), Color(.systemGray5)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    
                    Spacer()
                }
                
                // "AI is typing..." text
                Text("AI is typing...")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.leading, 20)
            }
        }
        .scaleEffect(pulseScale)
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Dot animations
        withAnimation(
            .easeInOut(duration: 0.8)
            .repeatForever(autoreverses: true)
            .delay(0.0)
        ) {
            dot1Scale = 1.3
            dot1Opacity = 1.0
        }
        
        withAnimation(
            .easeInOut(duration: 0.8)
            .repeatForever(autoreverses: true)
            .delay(0.2)
        ) {
            dot2Scale = 1.3
            dot2Opacity = 1.0
        }
        
        withAnimation(
            .easeInOut(duration: 0.8)
            .repeatForever(autoreverses: true)
            .delay(0.4)
        ) {
            dot3Scale = 1.3
            dot3Opacity = 1.0
        }
        
        // Overall pulse animation
        withAnimation(
            .easeInOut(duration: 1.5)
            .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.05
        }
    }
}

/// Individual typing dot with animation
struct TypingDot: View {
    @Binding var scale: Double
    @Binding var opacity: Double
    let delay: Double
    
    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 8, height: 8)
            .scaleEffect(scale)
            .opacity(opacity)
    }
}


#Preview {
    VStack(spacing: 20) {
        ModernTypingIndicator()
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
