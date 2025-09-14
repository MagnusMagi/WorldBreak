import SwiftUI

/// Enhanced search bar component with suggestions support
struct SearchBarView: View {
    @Binding var searchText: String
    let onSearchButtonClicked: () -> Void
    let onSuggestionSelected: ((String) -> Void)?
    let onVoiceSearch: (() -> Void)?
    let onImageSearch: (() -> Void)?
    
    @State private var isSearching = false
    @State private var showSuggestions = false
    
    init(
        searchText: Binding<String>,
        onSearchButtonClicked: @escaping () -> Void,
        onSuggestionSelected: ((String) -> Void)? = nil,
        onVoiceSearch: (() -> Void)? = nil,
        onImageSearch: (() -> Void)? = nil
    ) {
        self._searchText = searchText
        self.onSearchButtonClicked = onSearchButtonClicked
        self.onSuggestionSelected = onSuggestionSelected
        self.onVoiceSearch = onVoiceSearch
        self.onImageSearch = onImageSearch
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    
                    TextField("Search news...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onSubmit {
                            onSearchButtonClicked()
                            showSuggestions = false
                        }
                        .onChange(of: searchText) { _ in
                            showSuggestions = !searchText.isEmpty
                        }
                        .accessibilityLabel("Search text field")
                        .accessibilityHint("Enter search terms for news articles")
                    
                    // Voice Search Button
                    if let onVoiceSearch = onVoiceSearch {
                        Button(action: {
                            onVoiceSearch()
                            showSuggestions = false
                        }) {
                            Image(systemName: "mic.fill")
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                        .accessibilityLabel("Voice search")
                        .accessibilityHint("Start voice search to speak your query")
                    }
                    
                    // Image Search Button
                    if let onImageSearch = onImageSearch {
                        Button(action: {
                            onImageSearch()
                            showSuggestions = false
                        }) {
                            Image(systemName: "camera.fill")
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                        .accessibilityLabel("Image search")
                        .accessibilityHint("Search using images from camera or photo library")
                    }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            showSuggestions = false
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
                        showSuggestions = !searchText.isEmpty
                    }
                }
                
                if isSearching {
                    Button("Cancel") {
                        withAnimation(DesignSystem.Animation.quick) {
                            isSearching = false
                            searchText = ""
                            showSuggestions = false
                        }
                        // Dismiss keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            
            // Suggestions Dropdown
            if showSuggestions && onSuggestionSelected != nil {
                SearchSuggestionsDropdown(
                    searchText: searchText,
                    onSuggestionSelected: { suggestion in
                        searchText = suggestion
                        onSuggestionSelected?(suggestion)
                        showSuggestions = false
                        onSearchButtonClicked()
                    }
                )
            }
        }
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
