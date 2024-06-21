//
//  NewsViewModel.swift
//  NewsApp2
//
//  Created by Jungman Bae on 6/21/24.
//

import Foundation
import Combine

class NewsViewModel: ObservableObject {
    @Published var newsItems: [NewsItem] = []
    @Published var searchQuery = ""
    
    private let newsService = NewsService()
    private var cancellables = Set<AnyCancellable>()

    private lazy var searchNewsPublisher: AnyPublisher<NewsResponse, Error> = {
        $searchQuery
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .flatMap { query -> AnyPublisher<NewsResponse, Error> in
                return self.newsService.searchNews(query: query, page: 1, itemsPerPage: 20)
            }
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }()
    
    init() {
        searchNewsPublisher
            .catch { _ in Empty() }
            .sink { [weak self] response in
                self?.newsItems = response.items
            }
            .store(in: &cancellables)
    }
}
