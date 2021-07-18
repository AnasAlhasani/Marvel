//
//  XCTestCase+Publisher.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 27/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation
@testable import Marvel
import XCTest

extension AnyPublisher {
    private var result: Result<Output, Failure>? {
        var result: Result<Output, Failure>?
        let cancellable = convertToResult().sink { result = $0 }
        cancellable.cancel()
        return result
    }

    var value: Output? {
        try? result?.get()
    }

    var error: Error? {
        result?.error
    }
}

extension XCTestCase {
    func awaits<T: Publisher>(
        for publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Result<T.Output, Error> {
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "awaitsing publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    result = .failure(error)
                case .finished:
                    break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        return try XCTUnwrap(
            result,
            "awaitsed publisher did not produce any output",
            file: file,
            line: line
        )
    }
}
