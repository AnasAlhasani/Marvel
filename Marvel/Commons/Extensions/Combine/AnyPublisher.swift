//
//  AnyPublisher.swift
//  Marvel
//
//  Created by Anas Alhasani on 27/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation

extension AnyPublisher {
    static var empty: Self {
        Empty().eraseToAnyPublisher()
    }

    static func just(_ output: Output) -> Self {
        Just(output)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }

    static func fail(with error: Failure) -> Self {
        Fail(error: error).eraseToAnyPublisher()
    }
}

extension AnyPublisher where Output == Void {
    static var just: Self {
        .just(())
    }
}

extension AnyPublisher {
    static var passthroughSubject: Self {
        PassthroughSubject<Output, Failure>().eraseToAnyPublisher()
    }
}
