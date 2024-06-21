//
//  NewsService.swift
//  NewsApp2
//
//  Created by Jungman Bae on 6/21/24.
//

import Foundation
import Combine

struct APIErrorMessage: Decodable {
    var error: Bool
    var reason: String
}

enum APIError: LocalizedError {
    case invalidResponse
    case invalidRequestError(String)
    case transportError(Error)
    case validationError(String)
    case decodingError(Error)
    case serverError(statusCode: Int, reason: String? = nil, retryAfter: String? = nil)
    
    var errorDescription: String? {
        switch self {
        case .invalidRequestError(let message):
            return "Invalid request: \(message)"
        case .transportError(let error):
            return "Transport error: \(error)"
        case .invalidResponse:
            return "Invalid response"
        case .validationError(let reason):
            return "Validation error: \(reason)"
        case .decodingError:
            return "The server returned data in an unexpected format. Try updating the app."
        case .serverError(let statusCode, let reason, let retryAfter):
            return "Server error with code \(statusCode), reason: \(reason ?? "no reason given"), retry after: \(retryAfter ?? "no retry after provided")"
        }
    }
}

struct NewsService {
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
    
    func searchNews(query: String, page: Int, itemsPerPage: Int) -> AnyPublisher<NewsResponse, Error> {
        guard var components = URLComponents(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "start", value: String((page - 1) * itemsPerPage + 1)),
            URLQueryItem(name: "display", value: String(itemsPerPage))
        ]
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error -> Error in
                return APIError.transportError(error)
            }
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                print("Received reponse from server, now checking status code")
                
                guard let urlResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                if (200..<300) ~= urlResponse.statusCode { }
                else {
                    let decoder = JSONDecoder()
                    let apiError = try decoder.decode(APIErrorMessage.self, from: data)
                    
                    if urlResponse.statusCode == 400 {
                        throw APIError.validationError(apiError.reason)
                    }
                }
                return (data, response)
            }
        
            .map(\.data)
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
