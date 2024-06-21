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
            .sink { [weak self] newsItems in
                self?.newsItems = newsItems
                self?.fetchThumbnails()
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
    
    func fetchThumbnails() {
        for (index, item) in newsItems.enumerated() {
            guard let url = URL(string: item.originallink) else { continue }
            
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
        let ogImagePattern = "<meta\\s+property=[\"']og:image[\"']\\s+content=[\"'](.*?)[\"']\\s*/>"
        let twitterImagePattern = "<meta\\s+name=[\"']twitter:image[\"']\\s+content=[\"'](.*?)[\"']\\s*/>"
        
        if let ogImageURL = html.range(of: ogImagePattern, options: .regularExpression)
            .flatMap({ result in
                let start = html.index(result.lowerBound, offsetBy: 35)
                let end = html.index(result.upperBound, offsetBy: -4)
                return String(html[start..<end])
            }) {
            return ogImageURL
        }
        
        if let twitterImageURL = html.range(of: twitterImagePattern, options: .regularExpression)
            .flatMap({ result in
                let start = html.index(result.lowerBound, offsetBy: 38)
                let end = html.index(result.upperBound, offsetBy: -4)
                return String(html[start..<end])
            }) {
            return twitterImageURL
        }
        
        return nil
    }
}
