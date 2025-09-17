//
//  DesignSystem.swift
//  WorldBreak
//
//  Created by Magnus Magi on 16.09.2025.
//

import SwiftUI

// MARK: - Spacing Constants
struct Spacing {
    /// 4 points
    static let xs: CGFloat = 4
    /// 8 points
    static let sm: CGFloat = 8
    /// 12 points
    static let md: CGFloat = 12
    /// 16 points
    static let lg: CGFloat = 16
    /// 20 points
    static let xl: CGFloat = 20
    /// 24 points
    static let xxl: CGFloat = 24
    /// 32 points
    static let xxxl: CGFloat = 32
    /// 40 points
    static let xxxxl: CGFloat = 40
    /// 48 points
    static let xxxxxl: CGFloat = 48
}

// MARK: - Padding Constants
struct Padding {
    /// 8 points
    static let sm: CGFloat = 8
    /// 16 points
    static let md: CGFloat = 16
    /// 20 points
    static let lg: CGFloat = 20
    /// 24 points
    static let xl: CGFloat = 24
    /// 32 points
    static let xxl: CGFloat = 32
    /// 40 points
    static let xxxl: CGFloat = 40
    /// Safe area için horizontal padding
    static let horizontal: CGFloat = 20
    /// Sectionlar arası vertical padding
    static let sectionVertical: CGFloat = 40
}

// MARK: - Corner Radius Constants
struct CornerRadius {
    /// 4 points - Small elements
    static let sm: CGFloat = 4
    /// 8 points - Buttons, Cards
    static let md: CGFloat = 8
    /// 12 points - Containers
    static let lg: CGFloat = 12
    /// 16 points - Large containers
    static let xl: CGFloat = 16
    /// 20 points - Full rounded
    static let xxl: CGFloat = 20
}

// MARK: - Font Sizes
struct FontSize {
    /// 12 points - Captions
    static let caption: CGFloat = 12
    /// 14 points - Small text
    static let sm: CGFloat = 14
    /// 16 points - Body text
    static let body: CGFloat = 16
    /// 18 points - Subheadline
    static let subheadline: CGFloat = 18
    /// 20 points - Headline
    static let headline: CGFloat = 20
    static let title3: CGFloat = 24
    /// 24 points - Title 3
    static let title2: CGFloat = 28
    /// 28 points - Title 2
    static let title1: CGFloat = 32
    /// 32 points - Title 1
    static let largeTitle: CGFloat = 40
    /// 40 points - Large Title
    static let extraLargeTitle: CGFloat = 48
}

// MARK: - Font Weights
struct FontWeight {
    static let light = Font.Weight.light
    static let regular = Font.Weight.regular
    static let medium = Font.Weight.medium
    static let semibold = Font.Weight.semibold
    static let bold = Font.Weight.bold
    static let heavy = Font.Weight.heavy
}

// MARK: - Icon Sizes
struct IconSize {
    /// 16 points - Small icons
    static let sm: CGFloat = 16
    /// 20 points - Medium icons
    static let md: CGFloat = 20
    /// 24 points - Large icons
    static let lg: CGFloat = 24
    /// 32 points - Extra large icons
    static let xl: CGFloat = 32
    /// 40 points - Hero icons
    static let xxl: CGFloat = 40
    /// 60 points - Feature icons
    static let xxxl: CGFloat = 60
    /// 80 points - Large hero icons
    static let xxxxl: CGFloat = 80
    /// 100 points - Extra large hero icons
    static let xxxxxl: CGFloat = 100
}

// MARK: - Button Sizes
struct ButtonSize {
    /// 44 points - Minimum tap target size
    static let minTouchTarget: CGFloat = 44
    /// 48 points - Small button
    static let sm: CGFloat = 48
    /// 50 points - Medium button (default)
    static let md: CGFloat = 50
    /// 56 points - Large button
    static let lg: CGFloat = 56
    /// 64 points - Extra large button
    static let xl: CGFloat = 64
}

// MARK: - Animation Durations
struct AnimationDuration {
    /// 0.1 seconds - Instant
    static let instant: Double = 0.1
    /// 0.2 seconds - Fast
    static let fast: Double = 0.2
    /// 0.3 seconds - Standard
    static let standard: Double = 0.3
    /// 0.5 seconds - Medium
    static let medium: Double = 0.5
    /// 0.8 seconds - Slow
    static let slow: Double = 0.8
    /// 1.2 seconds - Very slow
    static let verySlow: Double = 1.2
}

// MARK: - Shadow Styles
struct ShadowStyle {
    /// Subtle shadow for cards
    static let subtle: (radius: CGFloat, x: CGFloat, y: CGFloat, opacity: Double) = (2, 0, 1, 0.05)
    /// Medium shadow for elevated elements
    static let medium: (radius: CGFloat, x: CGFloat, y: CGFloat, opacity: Double) = (4, 0, 2, 0.1)
    /// Strong shadow for prominent elements
    static let strong: (radius: CGFloat, x: CGFloat, y: CGFloat, opacity: Double) = (8, 0, 4, 0.15)
    /// Extra subtle shadow for minimal elevation
    static let extraSubtle: (radius: CGFloat, x: CGFloat, y: CGFloat, opacity: Double) = (1, 0, 1, 0.03)
}

// MARK: - Layout Constants
struct Layout {
    /// Maximum content width
    static let maxContentWidth: CGFloat = 400
    /// Grid columns for category selection
    static let categoryGridColumns = 3
    /// Card aspect ratio
    static let cardAspectRatio: CGFloat = 1.2
    /// Button minimum width
    static let buttonMinWidth: CGFloat = 120
}
