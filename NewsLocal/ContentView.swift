import SwiftUI
import Combine

/// Main content view for the app
struct ContentView: View {
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        Group {
            switch selectedTab {
            case .home:
                HomeView(selectedTab: $selectedTab)
            case .search:
                SearchView(selectedTab: $selectedTab)
            case .categories:
                CategoriesView(selectedTab: $selectedTab)
            case .profile:
                ProfileView(selectedTab: $selectedTab)
            }
        }
    }
}

// MARK: - Placeholder Views



// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDisplayName("Main App")
    }
}
