//
//  ListStateTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 08/01/2022.
//  Copyright © 2022 Anas Alhasani. All rights reserved.
//

@testable import Marvel
import XCTest

final class ListStateTests: XCTestCase {
    func testStatesWhenItemsAreEmpty() {
        func testState(_ state: ListState<Int>) {
            XCTAssertEqual(state, state)
            XCTAssertNil(state.nextPage)
            XCTAssertTrue(state.items.isEmpty)
        }

        let testCases: [ListState<Int>] = [
            .idle,
            .loading,
            .empty,
            .failed(MarvelError.general)
        ]

        testCases.forEach(testState)
    }

    func testPopulatedState() {
        let items = [1, 2, 3]
        let state: ListState<Int> = .populated(items)

        XCTAssertEqual(state.items, items)
        XCTAssertNil(state.nextPage)
    }

    func testPagingState() {
        let items = [1, 2, 3]
        let nextPage = 1
        let state: ListState<Int> = .paging(items, nextPage: nextPage)

        XCTAssertEqual(state.items, items)
        XCTAssertEqual(state.nextPage, nextPage)
    }
}
