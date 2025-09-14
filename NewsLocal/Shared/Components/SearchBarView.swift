import SwiftUI

/// Search bar component
struct SearchBarView: View {
    @Binding var searchText: String
    let onSearchButtonClicked: () -> Void
    
    @State private var isSearching = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                TextField("Search news...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onSubmit {
                        onSearchButtonClicked()
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.sm)
            .background(DesignSystem.Colors.backgroundSecondary)
            .cornerRadius(DesignSystem.CornerRadius.full)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.full)
                    .stroke(
                        isSearching ? DesignSystem.Colors.primary : Color.clear,
                        lineWidth: 2
                    )
            )
            .onTapGesture {
                withAnimation(DesignSystem.Animation.quick) {
                    isSearching = true
                }
            }
            
            if isSearching {
                Button("Cancel") {
                    withAnimation(DesignSystem.Animation.quick) {
                        isSearching = false
                        searchText = ""
                    }
                    // Dismiss keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .foregroundColor(DesignSystem.Colors.primary)
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
    }
}

// MARK: - Preview

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            SearchBarView(
                searchText: .constant(""),
                onSearchButtonClicked: {}
            )
            
            SearchBarView(
                searchText: .constant("Technology"),
                onSearchButtonClicked: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
