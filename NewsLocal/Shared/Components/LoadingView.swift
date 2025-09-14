import SwiftUI

/// Loading view component with different states
struct LoadingView: View {
    let message: String
    let style: LoadingStyle
    
    enum LoadingStyle {
        case spinner
        case dots
        case skeleton
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            switch style {
            case .spinner:
                ProgressView()
                    .scaleEffect(1.2)
                    .tint(DesignSystem.Colors.primary)
                
            case .dots:
                DotLoadingView()
                
            case .skeleton:
                SkeletonLoadingView()
            }
            
            if !message.isEmpty {
                Text(message)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignSystem.Colors.background)
    }
}

// MARK: - Dot Loading View

struct DotLoadingView: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(DesignSystem.Colors.primary)
                    .frame(width: 8, height: 8)
                    .offset(y: animationOffset)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animationOffset
                    )
            }
        }
        .onAppear {
            animationOffset = -10
        }
    }
}

// MARK: - Skeleton Loading View

struct SkeletonLoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            // Header skeleton
            HStack {
                Circle()
                    .fill(DesignSystem.Colors.backgroundSecondary)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Rectangle()
                        .fill(DesignSystem.Colors.backgroundSecondary)
                        .frame(height: 16)
                        .frame(maxWidth: 120)
                    
                    Rectangle()
                        .fill(DesignSystem.Colors.backgroundSecondary)
                        .frame(height: 12)
                        .frame(maxWidth: 80)
                }
                
                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            
            // Content skeleton
            VStack(spacing: DesignSystem.Spacing.sm) {
                Rectangle()
                    .fill(DesignSystem.Colors.backgroundSecondary)
                    .frame(height: 200)
                    .cornerRadius(DesignSystem.CornerRadius.sm)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Rectangle()
                        .fill(DesignSystem.Colors.backgroundSecondary)
                        .frame(height: 20)
                        .frame(maxWidth: .infinity)
                    
                    Rectangle()
                        .fill(DesignSystem.Colors.backgroundSecondary)
                        .frame(height: 20)
                        .frame(maxWidth: 280)
                    
                    Rectangle()
                        .fill(DesignSystem.Colors.backgroundSecondary)
                        .frame(height: 16)
                        .frame(maxWidth: 200)
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
        }
        .opacity(isAnimating ? 0.5 : 1.0)
        .animation(
            Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Convenience Initializers

extension LoadingView {
    static func spinner(message: String = "Loading...") -> LoadingView {
        LoadingView(message: message, style: .spinner)
    }
    
    static func dots(message: String = "Loading...") -> LoadingView {
        LoadingView(message: message, style: .dots)
    }
    
    static func skeleton() -> LoadingView {
        LoadingView(message: "", style: .skeleton)
    }
}

// MARK: - Preview

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            LoadingView.spinner(message: "Loading news...")
                .frame(height: 100)
            
            LoadingView.dots(message: "Searching...")
                .frame(height: 100)
            
            LoadingView.skeleton()
                .frame(height: 300)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
