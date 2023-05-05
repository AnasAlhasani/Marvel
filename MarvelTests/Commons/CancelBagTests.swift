//
//  CancelBagTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 05/05/2023.
//  Copyright © 2023 Anas Alhasani. All rights reserved.
//

import Combine
@testable import Marvel
import XCTest

final class CancelBagTests: XCTestCase {
    func testCancelBag() {
        var cancellationCount = 0 {
            let cancelBag = CancelBag()
            for _ in 0..<10 {
                Future<Never, Never> { _ in }
                    .handleEvents(receiveCancel: { cancellationCount += 1 })
                    .sink { _ in }
                    .store(in: cancelBag)
            }
        }()

        XCTAssertEqual(cancellationCount, 10)
    }
}
