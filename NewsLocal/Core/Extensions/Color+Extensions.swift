//
//  Color+Extensions.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

// MARK: - Color Extensions

extension Color {
    
    // MARK: - Initializers
    
    /// Initialize color from hex string
    /// - Parameter hex: Hex color string (e.g., "#FF0000" or "FF0000")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Initialize color from RGB values
    /// - Parameters:
    ///   - red: Red component (0-255)
    ///   - green: Green component (0-255)
    ///   - blue: Blue component (0-255)
    ///   - alpha: Alpha component (0-1)
    init(red: Int, green: Int, blue: Int, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: alpha
        )
    }
    
    // MARK: - Hex Conversion
    
    /// Convert color to hex string
    var hexString: String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
        return String(format: "#%06x", rgb)
    }
    
    /// Convert color to hex string with alpha
    var hexStringWithAlpha: String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgba: Int = (Int)(red * 255) << 24 | (Int)(green * 255) << 16 | (Int)(blue * 255) << 8 | (Int)(alpha * 255) << 0
        return String(format: "#%08x", rgba)
    }
    
    // MARK: - Color Manipulation
    
    /// Adjust color brightness
    /// - Parameter amount: Amount to adjust (-1.0 to 1.0)
    /// - Returns: Adjusted color
    func brightness(_ amount: Double) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        brightness = max(0, min(1, brightness + CGFloat(amount)))
        
        return Color(UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha))
    }
    
    /// Adjust color saturation
    /// - Parameter amount: Amount to adjust (-1.0 to 1.0)
    /// - Returns: Adjusted color
    func saturation(_ amount: Double) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        saturation = max(0, min(1, saturation + CGFloat(amount)))
        
        return Color(UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha))
    }
    
    /// Create lighter version of color
    /// - Parameter amount: Amount to lighten (0.0 to 1.0)
    /// - Returns: Lighter color
    func lighter(by amount: Double = 0.2) -> Color {
        return brightness(amount)
    }
    
    /// Create darker version of color
    /// - Parameter amount: Amount to darken (0.0 to 1.0)
    /// - Returns: Darker color
    func darker(by amount: Double = 0.2) -> Color {
        return brightness(-amount)
    }
    
    /// Create more saturated version of color
    /// - Parameter amount: Amount to increase saturation (0.0 to 1.0)
    /// - Returns: More saturated color
    func moreSaturated(by amount: Double = 0.2) -> Color {
        return saturation(amount)
    }
    
    /// Create less saturated version of color
    /// - Parameter amount: Amount to decrease saturation (0.0 to 1.0)
    /// - Returns: Less saturated color
    func lessSaturated(by amount: Double = 0.2) -> Color {
        return saturation(-amount)
    }
    
    /// Create color with opacity
    /// - Parameter opacity: Opacity value (0.0 to 1.0)
    /// - Returns: Color with specified opacity
    func opacity(_ opacity: Double) -> Color {
        let uiColor = UIColor(self)
        return Color(uiColor.withAlphaComponent(CGFloat(opacity)))
    }
    
    // MARK: - Color Blending
    
    /// Blend with another color
    /// - Parameters:
    ///   - other: Color to blend with
    ///   - intensity: Blend intensity (0.0 to 1.0)
    /// - Returns: Blended color
    func blend(with other: Color, intensity: Double = 0.5) -> Color {
        let uiColor1 = UIColor(self)
        let uiColor2 = UIColor(other)
        
        var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
        var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0
        
        uiColor1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        uiColor2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        let red = red1 * (1 - CGFloat(intensity)) + red2 * CGFloat(intensity)
        let green = green1 * (1 - CGFloat(intensity)) + green2 * CGFloat(intensity)
        let blue = blue1 * (1 - CGFloat(intensity)) + blue2 * CGFloat(intensity)
        let alpha = alpha1 * (1 - CGFloat(intensity)) + alpha2 * CGFloat(intensity)
        
        return Color(UIColor(red: red, green: green, blue: blue, alpha: alpha))
    }
    
    // MARK: - Accessibility
    
    /// Check if color is light or dark
    var isLight: Bool {
        let uiColor = UIColor(self)
        var white: CGFloat = 0
        uiColor.getWhite(&white, alpha: nil)
        return white > 0.5
    }
    
    /// Check if color is dark
    var isDark: Bool {
        return !isLight
    }
    
    /// Get contrasting color (black or white)
    var contrastingColor: Color {
        return isLight ? .black : .white
    }
    
    /// Get high contrast version of color
    var highContrast: Color {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Increase contrast by adjusting RGB values
        let contrastFactor: CGFloat = 0.3
        red = red > 0.5 ? min(1, red + contrastFactor) : max(0, red - contrastFactor)
        green = green > 0.5 ? min(1, green + contrastFactor) : max(0, green - contrastFactor)
        blue = blue > 0.5 ? min(1, blue + contrastFactor) : max(0, blue - contrastFactor)
        
        return Color(UIColor(red: red, green: green, blue: blue, alpha: alpha))
    }
    
    // MARK: - Category Colors
    
    /// Get color for news category
    /// - Parameter category: News category
    /// - Returns: Associated color
    static func forCategory(_ category: NewsCategory) -> Color {
        switch category.id {
        case "general":
            return Constants.Colors.categoryGeneral
        case "business":
            return Constants.Colors.categoryBusiness
        case "technology":
            return Constants.Colors.categoryTechnology
        case "science":
            return Constants.Colors.categoryScience
        case "health":
            return Constants.Colors.categoryHealth
        case "sports":
            return Constants.Colors.categorySports
        case "entertainment":
            return Constants.Colors.categoryEntertainment
        case "politics":
            return Constants.Colors.categoryPolitics
        case "world":
            return Constants.Colors.categoryWorld
        case "local":
            return Constants.Colors.categoryLocal
        default:
            return Constants.Colors.categoryGeneral
        }
    }
    
    /// Get color for priority level
    /// - Parameter priority: Priority level
    /// - Returns: Associated color
    static func forPriority(_ priority: BreakingNewsAlert.Priority) -> Color {
        switch priority {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .orange
        case .critical:
            return .red
        }
    }
    
    /// Get color for sentiment
    /// - Parameter sentiment: Sentiment score (-1.0 to 1.0)
    /// - Returns: Associated color
    static func forSentiment(_ sentiment: Double) -> Color {
        if sentiment > 0.2 {
            return .green // Positive
        } else if sentiment < -0.2 {
            return .red // Negative
        } else {
            return .gray // Neutral
        }
    }
    
    // MARK: - Theme Colors
    
    /// Primary theme color
    static var primary: Color {
        return Constants.Colors.primary
    }
    
    /// Secondary theme color
    static var secondary: Color {
        return Constants.Colors.secondary
    }
    
    /// Success color
    static var success: Color {
        return Constants.Colors.success
    }
    
    /// Warning color
    static var warning: Color {
        return Constants.Colors.warning
    }
    
    /// Error color
    static var error: Color {
        return Constants.Colors.error
    }
    
    /// Info color
    static var info: Color {
        return Constants.Colors.info
    }
    
    // MARK: - Semantic Colors
    
    /// Background color for current appearance
    static var background: Color {
        return Constants.Colors.background
    }
    
    /// Secondary background color
    static var secondaryBackground: Color {
        return Constants.Colors.secondaryBackground
    }
    
    /// Tertiary background color
    static var tertiaryBackground: Color {
        return Constants.Colors.tertiaryBackground
    }
    
    /// Label color for current appearance
    static var label: Color {
        return Constants.Colors.label
    }
    
    /// Secondary label color
    static var secondaryLabel: Color {
        return Constants.Colors.secondaryLabel
    }
    
    /// Tertiary label color
    static var tertiaryLabel: Color {
        return Constants.Colors.tertiaryLabel
    }
    
    /// Separator color
    static var separator: Color {
        return Constants.Colors.separator
    }
    
    // MARK: - Gradient Colors
    
    /// Create gradient from color
    /// - Parameter direction: Gradient direction
    /// - Returns: Linear gradient
    func gradient(direction: GradientDirection = .vertical) -> LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [self, self.opacity(0.8)]),
            startPoint: direction.startPoint,
            endPoint: direction.endPoint
        )
    }
    
    /// Create gradient between two colors
    /// - Parameters:
    ///   - other: Other color
    ///   - direction: Gradient direction
    /// - Returns: Linear gradient
    func gradient(to other: Color, direction: GradientDirection = .vertical) -> LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [self, other]),
            startPoint: direction.startPoint,
            endPoint: direction.endPoint
        )
    }
    
    // MARK: - Random Colors
    
    /// Generate random color
    static var random: Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
    
    /// Generate random pastel color
    static var randomPastel: Color {
        return Color(
            red: Double.random(in: 0.6...1),
            green: Double.random(in: 0.6...1),
            blue: Double.random(in: 0.6...1)
        )
    }
    
    /// Generate random vibrant color
    static var randomVibrant: Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
        return colors.randomElement() ?? .blue
    }
}

// MARK: - Gradient Direction

enum GradientDirection {
    case vertical
    case horizontal
    case diagonalUp
    case diagonalDown
    case radial
    
    var startPoint: UnitPoint {
        switch self {
        case .vertical:
            return .top
        case .horizontal:
            return .leading
        case .diagonalUp:
            return .bottomLeading
        case .diagonalDown:
            return .topLeading
        case .radial:
            return .center
        }
    }
    
    var endPoint: UnitPoint {
        switch self {
        case .vertical:
            return .bottom
        case .horizontal:
            return .trailing
        case .diagonalUp:
            return .topTrailing
        case .diagonalDown:
            return .bottomTrailing
        case .radial:
            return .center
        }
    }
}

// MARK: - Color Palette

struct ColorPalette {
    
    /// News category colors
    struct Category {
        static let general = Color(hex: "8E8E93")
        static let business = Color(hex: "007AFF")
        static let technology = Color(hex: "5856D6")
        static let science = Color(hex: "34C759")
        static let health = Color(hex: "FF3B30")
        static let sports = Color(hex: "FF9500")
        static let entertainment = Color(hex: "FF2D92")
        static let politics = Color(hex: "5AC8FA")
        static let world = Color(hex: "32D74B")
        static let local = Color(hex: "64D2FF")
    }
    
    /// Priority colors
    struct Priority {
        static let low = Color(hex: "34C759")
        static let medium = Color(hex: "FF9500")
        static let high = Color(hex: "FF3B30")
        static let critical = Color(hex: "FF2D92")
    }
    
    /// Status colors
    struct Status {
        static let success = Color(hex: "34C759")
        static let warning = Color(hex: "FF9500")
        static let error = Color(hex: "FF3B30")
        static let info = Color(hex: "007AFF")
    }
    
    /// UI colors
    struct UI {
        static let primary = Color(hex: "007AFF")
        static let secondary = Color(hex: "5856D6")
        static let accent = Color(hex: "FF9500")
        static let background = Color(UIColor.systemBackground)
        static let secondaryBackground = Color(UIColor.secondarySystemBackground)
        static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
        static let label = Color(UIColor.label)
        static let secondaryLabel = Color(UIColor.secondaryLabel)
        static let tertiaryLabel = Color(UIColor.tertiaryLabel)
        static let separator = Color(UIColor.separator)
    }
    
    /// Neutral colors
    struct Neutral {
        static let white = Color(hex: "FFFFFF")
        static let black = Color(hex: "000000")
        static let gray50 = Color(hex: "F9FAFB")
        static let gray100 = Color(hex: "F3F4F6")
        static let gray200 = Color(hex: "E5E7EB")
        static let gray300 = Color(hex: "D1D5DB")
        static let gray400 = Color(hex: "9CA3AF")
        static let gray500 = Color(hex: "6B7280")
        static let gray600 = Color(hex: "4B5563")
        static let gray700 = Color(hex: "374151")
        static let gray800 = Color(hex: "1F2937")
        static let gray900 = Color(hex: "111827")
    }
}

// MARK: - Color Utilities

extension Color {
    
    /// Create color from color name string
    /// - Parameter name: Color name (e.g., "red", "blue", "green")
    /// - Returns: Color if name is valid
    static func from(name: String) -> Color? {
        switch name.lowercased() {
        case "red":
            return .red
        case "blue":
            return .blue
        case "green":
            return .green
        case "yellow":
            return .yellow
        case "orange":
            return .orange
        case "purple":
            return .purple
        case "pink":
            return .pink
        case "gray", "grey":
            return .gray
        case "black":
            return .black
        case "white":
            return .white
        case "clear":
            return .clear
        default:
            return nil
        }
    }
    
    /// Get color name
    var name: String {
        let uiColor = UIColor(self)
        
        if uiColor == UIColor.red { return "red" }
        if uiColor == UIColor.blue { return "blue" }
        if uiColor == UIColor.green { return "green" }
        if uiColor == UIColor.yellow { return "yellow" }
        if uiColor == UIColor.orange { return "orange" }
        if uiColor == UIColor.purple { return "purple" }
        if uiColor == UIColor.systemPink { return "pink" }
        if uiColor == UIColor.gray { return "gray" }
        if uiColor == UIColor.black { return "black" }
        if uiColor == UIColor.white { return "white" }
        if uiColor == UIColor.clear { return "clear" }
        
        return "custom"
    }
    
    /// Check if two colors are approximately equal
    /// - Parameters:
    ///   - other: Other color to compare
    ///   - tolerance: Tolerance for comparison (0.0 to 1.0)
    /// - Returns: True if colors are approximately equal
    func isApproximatelyEqual(to other: Color, tolerance: Double = 0.01) -> Bool {
        let uiColor1 = UIColor(self)
        let uiColor2 = UIColor(other)
        
        var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
        var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0
        
        uiColor1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        uiColor2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        let redDiff = abs(red1 - red2)
        let greenDiff = abs(green1 - green2)
        let blueDiff = abs(blue1 - blue2)
        let alphaDiff = abs(alpha1 - alpha2)
        
        return redDiff < CGFloat(tolerance) &&
               greenDiff < CGFloat(tolerance) &&
               blueDiff < CGFloat(tolerance) &&
               alphaDiff < CGFloat(tolerance)
    }
}
