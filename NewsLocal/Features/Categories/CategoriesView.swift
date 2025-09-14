import SwiftUI

struct CategoriesView: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        NavigationView {
            StandardPageWrapper(
                title: "Categories",
                showCategories: false,
                selectedCategory: nil,
                selectedTab: .categories,
                onCategorySelected: nil,
                onTabSelected: { tab in
                    selectedTab = tab
                }
            ) {
                VStack {
                    Text("Categories View")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
                    Text("Category browsing will be implemented here")
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

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(selectedTab: .constant(.categories))
    }
}
