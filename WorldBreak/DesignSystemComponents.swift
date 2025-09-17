//
//  DesignSystemComponents.swift
//  WorldBreak
//
//  Created by Magnus Magi on 16.09.2025.
//

import SwiftUI

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let isEnabled: Bool
    
    init(title: String, icon: String? = nil, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: IconSize.md, weight: FontWeight.medium))
                }
                
                Text(title)
                    .font(.system(size: FontSize.headline, weight: FontWeight.semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: ButtonSize.md)
            .background(Color.primary)
            .smallCornerRadius()
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

// MARK: - Secondary Button
struct SecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let isEnabled: Bool
    
    init(title: String, icon: String? = nil, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: IconSize.md, weight: FontWeight.medium))
                }
                
                Text(title)
                    .font(.system(size: FontSize.headline, weight: FontWeight.semibold))
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .frame(height: ButtonSize.md)
            .background(Color(.systemGray6))
            .smallCornerRadius()
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

// MARK: - Action Button (for ContentView)
struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: (() -> Void)?
    
    init(title: String, icon: String, color: Color, action: (() -> Void)? = nil) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: Spacing.lg) {
                Image(systemName: icon)
                    .font(.system(size: IconSize.lg, weight: FontWeight.medium))
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: FontSize.headline, weight: FontWeight.semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: IconSize.md, weight: FontWeight.medium))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, Padding.lg)
            .padding(.vertical, Spacing.lg)
            .background(Color(.systemBackground))
            .standardCornerRadius()
            .subtleShadow()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let category: Category
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: Spacing.sm) {
                Image(systemName: category.icon)
                    .font(.system(size: IconSize.lg, weight: FontWeight.medium))
                    .foregroundColor(isSelected ? .white : .primary)
                    .frame(width: IconSize.lg, height: IconSize.lg)
                
                Text(category.name)
                    .font(.system(size: FontSize.caption, weight: FontWeight.medium))
                    .foregroundColor(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .fill(isSelected ? Color.primary : Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.md)
                            .stroke(Color(.systemGray4), lineWidth: isSelected ? 0 : 1)
                    )
            )
            .extraSubtleShadow()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Theme Card
struct ThemeCard: View {
    let theme: Theme
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.lg) {
                // Theme Preview
                VStack(spacing: Spacing.sm) {
                    RoundedRectangle(cornerRadius: CornerRadius.md)
                        .fill(theme.isDark == true ? Color.black : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.md)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .frame(width: 60, height: 40)
                    
                    Text(theme.name)
                        .font(.system(size: FontSize.caption, weight: FontWeight.medium))
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(theme.name)
                        .font(.system(size: FontSize.headline, weight: FontWeight.semibold))
                        .foregroundColor(.primary)
                    
                    Text(theme.description)
                        .font(.system(size: FontSize.sm, weight: FontWeight.regular))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Selection Indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: IconSize.lg, weight: FontWeight.medium))
                    .foregroundColor(isSelected ? .primary : Color(.tertiaryLabel))
            }
            .padding(.horizontal, Padding.lg)
            .padding(.vertical, Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .fill(isSelected ? Color.primary.opacity(0.1) : Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.lg)
                            .stroke(isSelected ? Color.primary : Color.clear, lineWidth: 2)
                    )
            )
            .subtleShadow()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - News Article Card
struct NewsArticleCard: View {
    let article: NewsArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Article Image Placeholder
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .fill(Color(.systemGray5))
                .frame(height: 200)
                .overlay(
                    VStack {
                        Image(systemName: "photo")
                            .font(.system(size: IconSize.xl))
                            .foregroundColor(.secondary)
                        Text("Image")
                            .font(.system(size: FontSize.caption, weight: FontWeight.medium))
                            .foregroundColor(.secondary)
                    }
                )
            
            VStack(alignment: .leading, spacing: Spacing.sm) {
                // Category Badge
                HStack {
                    Text(article.category.name)
                        .font(.system(size: FontSize.caption, weight: FontWeight.medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, Spacing.xs)
                        .background(article.category.color)
                        .cornerRadius(CornerRadius.sm)
                    
                    Spacer()
                    
                    Text(article.publishedAt, style: .relative)
                        .font(.system(size: FontSize.caption, weight: FontWeight.regular))
                        .foregroundColor(.secondary)
                }
                
                // Article Title
                Text(article.title)
                    .font(.system(size: FontSize.headline, weight: FontWeight.semibold))
                    .foregroundColor(.primary)
                    .lineLimit(3)
                
                // Article Summary
                Text(article.summary)
                    .font(.system(size: FontSize.body, weight: FontWeight.regular))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Source
                HStack {
                    Text(article.source)
                        .font(.system(size: FontSize.sm, weight: FontWeight.regular))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.bottom, Spacing.md)
        }
        .background(Color(.systemBackground))
        .standardCornerRadius()
        .subtleShadow()
    }
}

// MARK: - Category Tab
struct CategoryTab: View {
    let category: Category
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: category.icon)
                    .font(.system(size: IconSize.sm, weight: FontWeight.medium))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(category.name)
                    .font(.system(size: FontSize.caption, weight: FontWeight.medium))
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.xxl)
                    .fill(isSelected ? Color.primary : Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Loading View
struct LoadingView: View {
    let message: String
    
    init(message: String = "Loading...") {
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text(message)
                .font(.system(size: FontSize.body, weight: FontWeight.medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(icon: String, title: String, message: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            Image(systemName: icon)
                .font(.system(size: IconSize.xxxxl, weight: FontWeight.light))
                .foregroundColor(.secondary)
            
            VStack(spacing: Spacing.sm) {
                Text(title)
                    .font(.system(size: FontSize.title3, weight: FontWeight.semibold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.system(size: FontSize.body, weight: FontWeight.regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                PrimaryButton(title: actionTitle, action: action)
                    .padding(.horizontal, Padding.xl)
            }
        }
        .padding(.horizontal, Padding.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "Primary Button", icon: "arrow.right") {}
        SecondaryButton(title: "Secondary Button", icon: "gear") {}
        ActionButton(title: "Action Button", icon: "heart.fill", color: .red) {}
    }
    .padding()
}
