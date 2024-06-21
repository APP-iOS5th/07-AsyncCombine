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
    @Published var errorMessage: String?
    
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
        // 뉴스아이템 배열 바인딩 스트림
        searchNewsPublisher
            .catch { _ in Empty() }
            .map(\.items)
            .assign(to: \.newsItems, on: self)
            .store(in: &cancellables)
        
        // 에러 메시지 출력 스트림
        searchNewsPublisher
            .map { _ in nil as String? }
            .catch { error -> AnyPublisher<String?, Never> in
                Just(error.localizedDescription).eraseToAnyPublisher()
            }
            .print("error")
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)

    }
}
