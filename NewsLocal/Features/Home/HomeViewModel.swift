import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var isLoading = false
    @Published var error: AppError? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let newsService: NewsServiceProtocol
    
    init(newsService: NewsServiceProtocol = ServiceFactory.createNewsService(isMock: true)) {
        self.newsService = newsService
    }
    
    func fetchTopHeadlines() {
        isLoading = true
        newsService.fetchTopHeadlines(category: nil)
            .receive(on: DispatchQueue.main)
            .sink {
                [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: {
                [weak self] articles in
                self?.articles = articles
            }
            .store(in: &cancellables)
    }
    
    func fetchNewsByCategory(_ category: NewsCategory) {
        isLoading = true
        newsService.fetchTopHeadlines(category: category)
            .receive(on: DispatchQueue.main)
            .sink {
                [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: {
                [weak self] articles in
                self?.articles = articles
            }
            .store(in: &cancellables)
    }
}
