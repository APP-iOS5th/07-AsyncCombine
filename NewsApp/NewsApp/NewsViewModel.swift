//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Jungman Bae on 6/21/24.
//

import Foundation
import Combine

class NewsViewModel: ObservableObject {
    @Published var newsItems: [NewsItem] = []
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    @Published var isLoading = false
    
    private let newsService = NewsService()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var searchNewsPublisher: AnyPublisher<[NewsItem], Error> = {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .flatMap { [weak self] query -> AnyPublisher<[NewsItem], Error> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                self.isLoading = true
                self.errorMessage = nil
                return self.newsService.searchNews(query: query)
            }
            .share()
            .eraseToAnyPublisher()
    }()

    init() {
        // 로딩 상태 추적 스트림
        searchNewsPublisher
            .map { _ in false }
            .catch { _ in Just(false) }
            .prepend(true)
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        // newsItems 바인딩 스트림
        searchNewsPublisher
            .receive(on: DispatchQueue.main)
            .catch { _ in Empty() }
            .assign(to: \.newsItems, on: self)
            .store(in: &cancellables)
        
        // 에러 메시지 출력 스트림
        searchNewsPublisher
            .receive(on: DispatchQueue.main)
            .map { _ in nil as String? }
            .catch { error -> AnyPublisher<String?, Never> in
                Just(error.localizedDescription).eraseToAnyPublisher()
            }
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }
}
