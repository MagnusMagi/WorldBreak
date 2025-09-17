//
//  DesignSystemModifiers.swift
//  WorldBreak
//
//  Created by Magnus Magi on 16.09.2025.
//

import SwiftUI

// MARK: - View Modifiers for Consistent Styling
extension View {
    /// Standard horizontal padding for content
    func standardHorizontalPadding() -> some View {
        self.padding(.horizontal, Padding.horizontal)
    }
    
    /// Section spacing between major content blocks
    func sectionSpacing() -> some View {
        self.padding(.vertical, Padding.sectionVertical)
    }
    
    /// Standard corner radius for cards and containers
    func standardCornerRadius() -> some View {
        self.cornerRadius(CornerRadius.lg)
    }
    
    /// Small corner radius for buttons
    func smallCornerRadius() -> some View {
        self.cornerRadius(CornerRadius.md)
    }
    
    /// Subtle shadow for elevated elements
    func subtleShadow() -> some View {
        let style = ShadowStyle.subtle
        return self.shadow(color: .black.opacity(style.opacity), radius: style.radius, x: style.x, y: style.y)
    }
    
    /// Extra subtle shadow for minimal elevation
    func extraSubtleShadow() -> some View {
        let style = ShadowStyle.extraSubtle
        return self.shadow(color: .black.opacity(style.opacity), radius: style.radius, x: style.x, y: style.y)
    }
    
    /// Medium shadow for prominently elevated elements
    func mediumShadow() -> some View {
        let style = ShadowStyle.medium
        return self.shadow(color: .black.opacity(style.opacity), radius: style.radius, x: style.x, y: style.y)
    }
    
    /// Standard button styling
    func standardButtonStyle() -> some View {
        self
            .frame(height: ButtonSize.md)
            .smallCornerRadius()
            .mediumShadow()
    }
    
    /// Card container styling
    func cardStyle() -> some View {
        self
            .background(Color(.systemBackground))
            .standardCornerRadius()
            .subtleShadow()
    }
    
    /// Safe area content wrapper
    func safeAreaContent() -> some View {
        self
            .standardHorizontalPadding()
            .padding(.top, Padding.lg)
    }
}

// MARK: - Text Style Modifiers
extension Text {
    /// Large title style
    func largeTitleStyle() -> some View {
        self.font(.system(size: FontSize.largeTitle, weight: FontWeight.bold))
    }
    
    /// Extra large title style
    func extraLargeTitleStyle() -> some View {
        self.font(.system(size: FontSize.extraLargeTitle, weight: FontWeight.bold))
    }
    
    /// Title style
    func titleStyle() -> some View {
        self.font(.system(size: FontSize.title1, weight: FontWeight.bold))
    }
    
    /// Title 2 style
    func title2Style() -> some View {
        self.font(.system(size: FontSize.title2, weight: FontWeight.semibold))
    }
    
    /// Title 3 style
    func title3Style() -> some View {
        self.font(.system(size: FontSize.title3, weight: FontWeight.semibold))
    }
    
    /// Headline style
    func headlineStyle() -> some View {
        self.font(.system(size: FontSize.headline, weight: FontWeight.semibold))
    }
    
    /// Subheadline style
    func subheadlineStyle() -> some View {
        self.font(.system(size: FontSize.subheadline, weight: FontWeight.medium))
    }
    
    /// Body style
    func bodyStyle() -> some View {
        self.font(.system(size: FontSize.body, weight: FontWeight.regular))
    }
    
    /// Small text style
    func smallStyle() -> some View {
        self.font(.system(size: FontSize.sm, weight: FontWeight.regular))
    }
    
    /// Caption style
    func captionStyle() -> some View {
        self.font(.system(size: FontSize.caption, weight: FontWeight.regular))
            .foregroundColor(.secondary)
    }
    
    /// Primary text color
    func primaryText() -> some View {
        self.foregroundColor(.primary)
    }
    
    /// Secondary text color
    func secondaryText() -> some View {
        self.foregroundColor(.secondary)
    }
    
    /// Tertiary text color
    func tertiaryText() -> some View {
        self.foregroundColor(Color(.tertiaryLabel))
    }
}
