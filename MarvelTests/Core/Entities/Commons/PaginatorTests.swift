//
//  PaginatorTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 13/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

@testable import Marvel
import XCTest

final class PaginatorTests: XCTestCase {
    func test() {
        // Given
        let offset = 0
        let limit = 20
        let total = 40
        let count = 20
        let totalResults = EntityTestDouble.items(numberOfElements: total)
        var paginator = Paginator.value(
            offset: offset,
            limit: limit,
            total: total,
            count: count,
            results: .init(totalResults.prefix(limit))
        )

        // Then
        XCTAssertTrue(paginator.hasMorePages)
        XCTAssertEqual(paginator.nextOffset, offset + limit)

        // Given
        paginator = paginator.next(with: .init(totalResults.suffix(limit)))

        // Then
        XCTAssertFalse(paginator.hasMorePages)
        XCTAssertEqual(paginator.nextOffset, paginator.offset)
    }
}

extension Paginator {
    static func value(
        offset: Int = 0,
        limit: Int = 20,
        total: Int = 40,
        count: Int = 20,
        results: [Value]
    ) -> Self {
        .init(
            offset: offset,
            limit: limit,
            total: total,
            count: count,
            results: results
        )
    }

    func next(with results: [Value]) -> Self {
        .init(
            offset: nextOffset,
            limit: limit,
            total: total,
            count: count,
            results: results
        )
    }
}
