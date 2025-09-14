import SwiftUI

/// Modern welcome message with animated elements
struct ModernWelcomeView: View {
    @State private var sparkleRotation = 0.0
    @State private var titleScale = 0.8
    @State private var subtitleOpacity = 0.0
    @State private var featuresOpacity = 0.0
    @State private var pulseScale = 1.0
    
    var body: some View {
        VStack(spacing: 24) {
            // Animated sparkle icon
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.purple.opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(pulseScale)
                    .animation(
                        .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                        value: pulseScale
                    )
                
                // Main sparkle
                Image(systemName: "sparkles")
                    .font(.system(size: 48, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.purple, Color.blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .rotationEffect(.degrees(sparkleRotation))
                    .animation(
                        .linear(duration: 4).repeatForever(autoreverses: false),
                        value: sparkleRotation
                    )
            }
            
            // Title and subtitle
            VStack(spacing: 12) {
                Text("AI News Assistant")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .scaleEffect(titleScale)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7), value: titleScale)
                
                Text("Your intelligent companion for staying informed")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(subtitleOpacity)
                    .animation(.easeInOut(duration: 0.8).delay(0.3), value: subtitleOpacity)
            }
            
            // Feature highlights
            VStack(spacing: 16) {
                WelcomeFeatureRow(
                    icon: "⚡",
                    title: "Lightning Fast",
                    description: "Get instant responses to your news queries"
                )
                .opacity(featuresOpacity)
                .animation(.easeInOut(duration: 0.6).delay(0.6), value: featuresOpacity)
                
                WelcomeFeatureRow(
                    icon: "🎯",
                    title: "Precision Answers",
                    description: "Accurate and relevant news information"
                )
                .opacity(featuresOpacity)
                .animation(.easeInOut(duration: 0.6).delay(0.8), value: featuresOpacity)
                
                WelcomeFeatureRow(
                    icon: "🌍",
                    title: "Global Coverage",
                    description: "News from around the world at your fingertips"
                )
                .opacity(featuresOpacity)
                .animation(.easeInOut(duration: 0.6).delay(1.0), value: featuresOpacity)
            }
            
            // Call to action
            VStack(spacing: 8) {
                Text("Ready to explore?")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Ask me anything about news, or try one of the quick actions below")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .opacity(featuresOpacity)
            .animation(.easeInOut(duration: 0.6).delay(1.2), value: featuresOpacity)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 40)
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        sparkleRotation = 360
        pulseScale = 1.2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                titleScale = 1.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation {
                subtitleOpacity = 1.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation {
                featuresOpacity = 1.0
            }
        }
    }
}

/// Individual feature row for welcome view
struct WelcomeFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Text(icon)
                .font(.system(size: 24))
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                )
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
    }
}

/// Compact welcome view for smaller spaces
struct CompactWelcomeView: View {
    @State private var sparkleRotation = 0.0
    @State private var titleScale = 0.9
    @State private var subtitleOpacity = 0.0
    
    var body: some View {
        VStack(spacing: 16) {
            // Compact sparkle
            Image(systemName: "sparkles")
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.purple, Color.blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .rotationEffect(.degrees(sparkleRotation))
                .animation(
                    .linear(duration: 3).repeatForever(autoreverses: false),
                    value: sparkleRotation
                )
            
            // Compact text
            VStack(spacing: 8) {
                Text("AI News Assistant")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .scaleEffect(titleScale)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: titleScale)
                
                Text("Ask me anything about news, get summaries, or discover trending topics!")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(subtitleOpacity)
                    .animation(.easeInOut(duration: 0.6).delay(0.2), value: subtitleOpacity)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .onAppear {
            sparkleRotation = 360
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    titleScale = 1.0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    subtitleOpacity = 1.0
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 40) {
            ModernWelcomeView()
            
            Divider()
                .padding(.horizontal, 32)
            
            CompactWelcomeView()
        }
    }
    .background(Color(.systemGroupedBackground))
}
