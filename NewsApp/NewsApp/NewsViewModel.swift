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
    @Published var hasMoreData = false
    @Published private var currentPage = 1

    private let newsService = NewsService()
    private var cancellables = Set<AnyCancellable>()
    
    private var totalPage = 0
    private let itemsPerPage = 20

    private lazy var searchNewsPublisher: AnyPublisher<NewsResponse, Error> = {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .flatMap { [weak self] query -> AnyPublisher<NewsResponse, Error> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                self.errorMessage = nil
                self.currentPage = 1
                self.hasMoreData = false
                return self.newsService.searchNews(query: query, page: self.currentPage, itemsPerPage: self.itemsPerPage)
            }
            .share()
            .eraseToAnyPublisher()
    }()
    
    private lazy var paginationPublisher: AnyPublisher<[NewsItem], Error> = {
        $currentPage
            .filter { $0 > 1 }
            .flatMap { [weak self] page -> AnyPublisher<[NewsItem], Error> in
                guard let self = self, !self.searchQuery.isEmpty else {
                    return Empty().eraseToAnyPublisher()
                }
                return self.newsService.searchNews(query: self.searchQuery, page: page, itemsPerPage: self.itemsPerPage)
                    .handleEvents(receiveOutput: { [weak self] response in
                        self?.totalPage = response.total
                        self?.hasMoreData = (self?.newsItems.count ?? 0) + response.items.count < response.total
                    })
                    .map(\.items)
                    .eraseToAnyPublisher()
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
        
        paginationPublisher
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
            .sink { [weak self] response in
                self?.newsItems = response.items
                self?.hasMoreData = response.items.count < response.total
                self?.totalPage = response.total
                self?.fetchThumbnails(for: response.items)
            }
            .store(in: &cancellables)

        
        // 페이지네이션 스트림
        paginationPublisher
            .receive(on: DispatchQueue.main)
            .catch { _ in Empty() }
            .sink { [weak self] newsItems in
                self?.newsItems.append(contentsOf: newsItems)
                self?.fetchThumbnails(for: newsItems)
            }
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
    
    func loadMore() {
        guard !isLoading, hasMoreData else { return }
        currentPage += 1
    }
    
    func fetchThumbnails(for items: [NewsItem] = []) {
        for (index, item) in newsItems.enumerated() {
            guard var urlComponents = URLComponents(string: item.originallink) else { continue }
            
            // Force HTTPS
            urlComponents.scheme = "https"
            
            guard let url = urlComponents.url else { continue }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .map { String(data: $0, encoding: .utf8) ?? "" }
                .map { self.extractThumbnailURL(from: $0) }
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("Error fetching thumbnail for \(item.title): \(error)")
                    }
                } receiveValue: { [weak self] thumbnailURL in
                    self?.newsItems[index].imageURL = thumbnailURL
                }
                .store(in: &cancellables)
        }
    }
    
    func extractThumbnailURL(from html: String) -> String? {
        let patterns = [
            // Open Graph
            "<meta\\s+property=[\"']og:image[\"']\\s+content=[\"'](.*?)[\"']\\s*/>",
            // Twitter Card
            "<meta\\s+name=[\"']twitter:image[\"']\\s+content=[\"'](.*?)[\"']\\s*/>",
            // Standard meta image
            "<meta\\s+name=[\"']image[\"']\\s+content=[\"'](.*?)[\"']\\s*/>",
            // Link tag with image
            "<link\\s+rel=[\"']image_src[\"']\\s+href=[\"'](.*?)[\"']\\s*/>",
            // First img tag src
            "<img\\s+[^>]*src=[\"'](.*?)[\"'][^>]*>",
            // Article:image (used by some sites)
            "<meta\\s+property=[\"']article:image[\"']\\s+content=[\"'](.*?)[\"']\\s*/>"
        ]
        
        for pattern in patterns {
            if let imageURL = html.range(of: pattern, options: .regularExpression)
                .flatMap({ result -> String? in
                    let fullMatch = html[result]
                    let quotationMarks = ["\"", "'"]
                    for mark in quotationMarks {
                        if let start = fullMatch.range(of: "\(mark)http")?.upperBound,
                           let end = fullMatch[start...].range(of: mark)?.lowerBound {
                            return String(fullMatch[start..<end])
                        }
                    }
                    return nil
                }) {
                return forceHTTPS(url: imageURL)
            }
        }
        
        return nil
    }

    private func forceHTTPS(url: String) -> String {
        guard var urlComponents = URLComponents(string: url) else { return url }
        urlComponents.scheme = "https"
        return urlComponents.url?.absoluteString ?? url
    }
}
