import SwiftUI
import Combine

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State private var selectedCategory: NewsCategory? = nil
    @Binding var selectedTab: TabItem
    
    var body: some View {
        NavigationView {
            StandardPageWrapper(
                title: "Home",
                showCategories: true,
                selectedCategory: selectedCategory,
                selectedTab: .home,
                onCategorySelected: { category in
                    selectedCategory = category
                    if let category = category {
                        viewModel.fetchNewsByCategory(category)
                    } else {
                        viewModel.fetchTopHeadlines()
                    }
                },
                onTabSelected: { tab in
                    selectedTab = tab
                }
            ) {
                // Ana içerik
                Group {
                    if viewModel.isLoading {
                        ProgressView("Loading News...")
                    } else if let error = viewModel.error {
                        Text("Error: \(error.localizedDescription)")
                            .foregroundColor(.red)
                    } else {
                        List(viewModel.articles) {
                            article in NewsArticleRow(article: article)
                        }
                        .padding(.bottom, 100) // Bottombar için space
                    }
                }
            }
            .onAppear {
                viewModel.fetchTopHeadlines()
            }
        }
    }
}

struct NewsArticleRow: View {
    let article: NewsArticle
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title)
                .font(.headline)
            Text(article.summary)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(.home))
    }
}
