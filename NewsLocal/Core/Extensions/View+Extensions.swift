//
//  View+Extensions.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

// MARK: - View Extensions

extension View {
    
    // MARK: - Layout Modifiers
    
    /// Center the view both horizontally and vertically
    func centered() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /// Apply padding with consistent spacing
    /// - Parameter spacing: Spacing value
    /// - Returns: View with padding
    func padding(_ spacing: Constants.UI.Padding) -> some View {
        return self.padding(spacing.rawValue)
    }
    
    /// Apply corner radius with consistent styling
    /// - Parameter radius: Corner radius value
    /// - Returns: View with corner radius
    func cornerRadius(_ radius: Constants.UI.CornerRadius) -> some View {
        return self.cornerRadius(radius.rawValue)
    }
    
    /// Apply shadow with consistent styling
    /// - Parameter shadow: Shadow configuration
    /// - Returns: View with shadow
    func shadow(_ shadow: Constants.UI.Shadow) -> some View {
        return self.shadow(
            color: .black.opacity(Double(shadow.opacity)),
            radius: shadow.radius,
            x: 0,
            y: 2
        )
    }
    
    // MARK: - Conditional Modifiers
    
    /// Apply modifier conditionally
    /// - Parameters:
    ///   - condition: Condition to check
    ///   - transform: Transform to apply if condition is true
    /// - Returns: Transformed view
    func conditionalModifier<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        Group {
            if condition {
                transform(self)
            } else {
                self
            }
        }
    }
    
    /// Apply modifier if condition is true
    /// - Parameters:
    ///   - condition: Condition to check
    ///   - transform: Transform to apply
    /// - Returns: Conditionally transformed view
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        return conditionalModifier(condition, transform: transform)
    }
    
    /// Apply modifier if condition is true, otherwise apply alternative
    /// - Parameters:
    ///   - condition: Condition to check
    ///   - ifTransform: Transform to apply if true
    ///   - elseTransform: Transform to apply if false
    /// - Returns: Conditionally transformed view
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        Group {
            if condition {
                ifTransform(self)
            } else {
                elseTransform(self)
            }
        }
    }
    
    // MARK: - Animation Modifiers
    
    /// Apply animation with consistent timing
    /// - Parameters:
    ///   - animation: Animation to apply
    ///   - value: Value to animate
    /// - Returns: Animated view
    func animate<T: Equatable>(
        _ animation: Animation = Constants.UI.springAnimation,
        value: T
    ) -> some View {
        return self.animation(animation, value: value)
    }
    
    /// Apply spring animation
    /// - Parameter value: Value to animate
    /// - Returns: Spring animated view
    func springAnimation<T: Equatable>(value: T) -> some View {
        return self.animation(Constants.UI.springAnimation, value: value)
    }
    
    /// Apply ease in out animation
    /// - Parameter value: Value to animate
    /// - Returns: Ease in out animated view
    func easeInOutAnimation<T: Equatable>(value: T) -> some View {
        return self.animation(Constants.UI.easeInOutAnimation, value: value)
    }
    
    // MARK: - Visual Effects
    
    /// Apply opacity with animation
    /// - Parameters:
    ///   - opacity: Opacity value
    ///   - animation: Animation to apply
    /// - Returns: View with animated opacity
    func opacity(_ opacity: Double, animation: Animation = .easeInOut) -> some View {
        return self.opacity(opacity)
            .animation(animation, value: opacity)
    }
    
    
    
    // MARK: - Layout Helpers
    
    // MARK: - Accessibility
    
    // MARK: - Gesture Modifiers
    
    // MARK: - Loading States
    
    /// Show loading overlay when condition is true
    /// - Parameters:
    ///   - isLoading: Loading state
    ///   - message: Loading message
    /// - Returns: View with loading overlay
    func loadingOverlay(isLoading: Bool, message: String = "Loading...") -> some View {
        return self.overlay(
            Group {
                if isLoading {
                    LoadingView(message: message, style: .spinner)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(Constants.UI.CornerRadius.medium.rawValue)
                }
            }
        )
    }
    
    /// Show loading indicator when condition is true
    /// - Parameter isLoading: Loading state
    /// - Returns: View with loading indicator
    func loadingIndicator(isLoading: Bool) -> some View {
        return self.overlay(
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.2)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(Constants.UI.CornerRadius.medium.rawValue)
                        .shadow(Constants.UI.Shadow.medium)
                }
            }
        )
    }
    
    // MARK: - Error States
    
    /// Show error overlay when condition is true
    /// - Parameters:
    ///   - isError: Error state
    ///   - error: Error message
    ///   - retryAction: Retry action
    /// - Returns: View with error overlay
    func errorOverlay(
        isError: Bool,
        error: String,
        retryAction: @escaping () -> Void
    ) -> some View {
        return self.overlay(
            Group {
                if isError {
                    VStack {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                        Button("Retry", action: retryAction)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding()
                }
            }
        )
    }
    
    // MARK: - Empty States
    
    /// Show empty state when condition is true
    /// - Parameters:
    ///   - isEmpty: Empty state
    ///   - title: Empty state title
    ///   - message: Empty state message
    ///   - actionTitle: Action button title
    ///   - action: Action to perform
    /// - Returns: View with empty state
    func emptyState(
        isEmpty: Bool,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) -> some View {
        return self.overlay(
            Group {
                if isEmpty {
                    EmptyStateView(
                        title: title,
                        message: message,
                        actionTitle: actionTitle,
                        action: action
                    )
                    .padding()
                }
            }
        )
    }
    
    // MARK: - Navigation
    
    /// Navigate to destination when condition is true
    /// - Parameters:
    ///   - isActive: Navigation state
    ///   - destination: Destination view
    /// - Returns: View with navigation
    func navigate<Destination: View>(
        isActive: Bool,
        destination: Destination
    ) -> some View {
        return NavigationLink(value: isActive) {
            self
        }
        .navigationDestination(isPresented: .constant(isActive)) {
            destination
        }
    }
    
    /// Navigate to destination with binding
    /// - Parameters:
    ///   - isActive: Navigation binding
    ///   - destination: Destination view
    /// - Returns: View with navigation
    func navigate<Destination: View>(
        isActive: Binding<Bool>,
        destination: Destination
    ) -> some View {
        return NavigationLink(value: isActive.wrappedValue) {
            self
        }
        .navigationDestination(isPresented: isActive) {
            destination
        }
    }
    
    // MARK: - Sheet Presentation
    
    // MARK: - Alert Presentation
    
    // MARK: - Debug Helpers
    
    /// Add debug border for development
    /// - Parameters:
    ///   - color: Border color
    ///   - width: Border width
    /// - Returns: View with debug border
    func debugBorder(color: Color = .red, width: CGFloat = 1) -> some View {
        #if DEBUG
        return self.border(color, width: width)
        #else
        return self
        #endif
    }
    
    /// Add debug background for development
    /// - Parameter color: Background color
    /// - Returns: View with debug background
    func debugBackground(color: Color = .red.opacity(0.3)) -> some View {
        #if DEBUG
        return self.background(color)
        #else
        return self
        #endif
    }
    
    /// Print debug information
    /// - Parameter message: Debug message
    /// - Returns: View with debug print
    func debugPrint(_ message: String) -> some View {
        #if DEBUG
        return self.onAppear {
            print("DEBUG: \(message)")
        }
        #else
        return self
        #endif
    }
}

// MARK: - Helper Views

struct GenericErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: Constants.UI.Padding.md.rawValue) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text("Error")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct EmptyStateView: View {
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: Constants.UI.Padding.md.rawValue) {
            Image(systemName: "tray")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}
