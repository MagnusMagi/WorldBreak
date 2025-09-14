import SwiftUI

struct SearchView: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        NavigationView {
            StandardPageWrapper(
                title: "Search",
                showCategories: false,
                selectedCategory: nil,
                selectedTab: .search,
                onCategorySelected: nil,
                onTabSelected: { tab in
                    selectedTab = tab
                }
            ) {
                VStack {
                    Text("Search View")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
                    Text("Search functionality will be implemented here")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(selectedTab: .constant(.search))
    }
}
