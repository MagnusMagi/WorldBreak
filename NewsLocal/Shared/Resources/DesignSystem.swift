import SwiftUI

/// Design system for NewsLocal app
struct DesignSystem {
    
    // MARK: - Colors
    
    struct Colors {
        // Primary Colors
        static let primary = Color.blue
        static let primaryDark = Color.blue.opacity(0.8)
        static let primaryLight = Color.blue.opacity(0.6)
        
        // Secondary Colors
        static let secondary = Color.gray
        static let accent = Color.orange
        
        // Background Colors
        static let background = Color(.systemBackground)
        static let backgroundSecondary = Color(.secondarySystemBackground)
        static let backgroundTertiary = Color(.tertiarySystemBackground)
        
        // Text Colors
        static let textPrimary = Color(.label)
        static let textSecondary = Color(.secondaryLabel)
        static let textTertiary = Color(.tertiaryLabel)
        
        // Surface Colors
        static let surface = Color(.systemBackground)
        static let surfaceElevated = Color(.secondarySystemBackground)
        
        // Status Colors
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        static let info = Color.blue
        
        // UI Element Colors
        static let border = Color(.separator)
        static let shadow = Color.black.opacity(0.1)
        
        // Breaking News
        static let breakingNews = Color.red
        
        // Category Colors
        static let categoryGeneral = Color.blue
        static let categoryTechnology = Color.blue
        static let categoryBusiness = Color.green
        static let categorySports = Color.orange
        static let categoryHealth = Color.pink
        static let categoryScience = Color.purple
        static let categoryEntertainment = Color.yellow
        static let categoryPolitics = Color.red
        static let categoryWorld = Color.teal
        static let categoryLocal = Color.teal
    }
    
    // MARK: - Typography
    
    struct Typography {
        // Headlines
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
        static let title1 = Font.system(size: 28, weight: .bold, design: .default)
        static let title2 = Font.system(size: 22, weight: .bold, design: .default)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
        
        // Body Text
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let bodyBold = Font.system(size: 17, weight: .semibold, design: .default)
        static let callout = Font.system(size: 16, weight: .regular, design: .default)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        
        // Captions
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption1 = Font.system(size: 12, weight: .regular, design: .default)
        static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
        
        // Special
        static let button = Font.system(size: 16, weight: .semibold, design: .default)
        static let tabBar = Font.system(size: 10, weight: .medium, design: .default)
    }
    
    // MARK: - Spacing
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        
        // Component specific
        static let cardPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 24
        static let itemSpacing: CGFloat = 12
    }
    
    // MARK: - Corner Radius
    
    struct CornerRadius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let full: CGFloat = 999
    }
    
    // MARK: - Shadows
    
    struct Shadow {
        static let small = ShadowStyle(
            color: Color.black.opacity(0.1),
            radius: 2,
            x: 0,
            y: 1
        )
        
        static let medium = ShadowStyle(
            color: Color.black.opacity(0.15),
            radius: 8,
            x: 0,
            y: 4
        )
        
        static let large = ShadowStyle(
            color: Color.black.opacity(0.2),
            radius: 16,
            x: 0,
            y: 8
        )
    }
    
    // MARK: - Animation
    
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let spring = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.8)
    }
}

// MARK: - Shadow Style

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions for Design System

extension View {
    
    // MARK: - Typography Modifiers
    
    func largeTitleStyle() -> some View {
        self.font(DesignSystem.Typography.largeTitle)
            .foregroundColor(DesignSystem.Colors.textPrimary)
    }
    
    func title1Style() -> some View {
        self.font(DesignSystem.Typography.title1)
            .foregroundColor(DesignSystem.Colors.textPrimary)
    }
    
    func title2Style() -> some View {
        self.font(DesignSystem.Typography.title2)
            .foregroundColor(DesignSystem.Colors.textPrimary)
    }
    
    func title3Style() -> some View {
        self.font(DesignSystem.Typography.title3)
            .foregroundColor(DesignSystem.Colors.textPrimary)
    }
    
    func bodyStyle() -> some View {
        self.font(DesignSystem.Typography.body)
            .foregroundColor(DesignSystem.Colors.textPrimary)
    }
    
    func bodyBoldStyle() -> some View {
        self.font(DesignSystem.Typography.bodyBold)
            .foregroundColor(DesignSystem.Colors.textPrimary)
    }
    
    func captionStyle() -> some View {
        self.font(DesignSystem.Typography.caption1)
            .foregroundColor(DesignSystem.Colors.textSecondary)
    }
    
    func footnoteStyle() -> some View {
        self.font(DesignSystem.Typography.footnote)
            .foregroundColor(DesignSystem.Colors.textSecondary)
    }
    
    // MARK: - Card Modifiers
    
    func cardStyle() -> some View {
        self
            .background(DesignSystem.Colors.surface)
            .cornerRadius(DesignSystem.CornerRadius.md)
            .shadow(
                color: DesignSystem.Shadow.small.color,
                radius: DesignSystem.Shadow.small.radius,
                x: DesignSystem.Shadow.small.x,
                y: DesignSystem.Shadow.small.y
            )
    }
    
    func elevatedCardStyle() -> some View {
        self
            .background(DesignSystem.Colors.surfaceElevated)
            .cornerRadius(DesignSystem.CornerRadius.md)
            .shadow(
                color: DesignSystem.Shadow.medium.color,
                radius: DesignSystem.Shadow.medium.radius,
                x: DesignSystem.Shadow.medium.x,
                y: DesignSystem.Shadow.medium.y
            )
    }
    
    // MARK: - Button Modifiers
    
    func primaryButtonStyle() -> some View {
        self
            .font(DesignSystem.Typography.button)
            .foregroundColor(.white)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.primary)
            .cornerRadius(DesignSystem.CornerRadius.md)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(DesignSystem.Typography.button)
            .foregroundColor(DesignSystem.Colors.primary)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.primary.opacity(0.1))
            .cornerRadius(DesignSystem.CornerRadius.md)
    }
    
    // MARK: - Spacing Modifiers
    
    func paddingXS() -> some View {
        self.padding(DesignSystem.Spacing.xs)
    }
    
    func paddingSM() -> some View {
        self.padding(DesignSystem.Spacing.sm)
    }
    
    func paddingMD() -> some View {
        self.padding(DesignSystem.Spacing.md)
    }
    
    func paddingLG() -> some View {
        self.padding(DesignSystem.Spacing.lg)
    }
    
    func paddingXL() -> some View {
        self.padding(DesignSystem.Spacing.xl)
    }
}
