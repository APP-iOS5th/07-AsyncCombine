//
//  NewsService.swift
//  NewsApp
//
//  Created by Jungman Bae on 6/21/24.
//

import Foundation
import Combine

class NewsService {
    private let baseURL = "https://openapi.naver.com/v1/search/news.json"
    private let clientID: String
    private let clientSecret: String
    
    init() {
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String,
              let clientSecret = Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String else {
            fatalError("CLIENT_ID or CLIENT_SECRET not set in plist")
        }
        self.clientID = clientID
        self.clientSecret = clientSecret
    }
    
    func searchNews(query: String) -> AnyPublisher<[NewsItem], Error> {
        guard let url = URL(string: "\(baseURL)?query=\(query)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
                
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .map(\.items)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
