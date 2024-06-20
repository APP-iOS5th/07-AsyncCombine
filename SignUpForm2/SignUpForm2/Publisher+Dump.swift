//
//  Publisher+Dump.swift
//  SignUpForm2
//
//  Created by Jungman Bae on 6/20/24.
//

import Foundation
import Combine

extension Publisher {
    func dump() -> AnyPublisher<Self.Output, Self.Failure> {
        handleEvents(receiveOutput: { value in
            Swift.dump(value)
        }, receiveCompletion: { value in
            Swift.print(">>")
            Swift.dump(value)
        })
        .eraseToAnyPublisher()
    }
}
