//
//  Helper.swift
//  SignUpForm2
//
//  Created by Jungman Bae on 6/20/24.
//

import Foundation
import Combine

struct UserNameAvailableMessage: Codable {
    var isAvailable: Bool
    var userName: String
}

struct APIErrorMessage: Decodable {
    var error: Bool
    var reason: String
}

enum APIError: LocalizedError {
    case invalidResponse
}

extension Publisher {
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map(Result.success)
            .catch { error in
                Just(.failure(error))
            }
            .eraseToAnyPublisher()
    }
}
