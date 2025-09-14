import SwiftUI
import Combine

/// Tab items for the main navigation
enum TabItem: CaseIterable {
    case home
    case search
    case categories
    case profile
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .categories:
            return "Categories"
        case .profile:
            return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .search:
            return "magnifyingglass"
        case .categories:
            return "list.bullet"
        case .profile:
            return "person"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .home:
            return "house.fill"
        case .search:
            return "magnifyingglass"
        case .categories:
            return "list.bullet"
        case .profile:
            return "person.fill"
        }
    }
}

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
