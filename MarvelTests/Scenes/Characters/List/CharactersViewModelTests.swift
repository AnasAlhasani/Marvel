//
//  CharactersViewModelTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

@testable import Marvel
@testable import Promises
import XCTest

final class CharactersViewModelTests: XCTestCase {
    var routerSpy: CharactersListRouterSpy!
    var useCaseStub: CharacterUseCaseStub!
    var throttlerSpy: ThrottlerSpy!
    var viewModel: CharactersViewModel!

    override func setUp() {
        super.setUp()
        routerSpy = .init()
        useCaseStub = .init()
        throttlerSpy = .init()
        viewModel = .init(
            router: routerSpy,
            characterUseCase: useCaseStub,
            throttler: throttlerSpy
        )
    }

    override func tearDown() {
        routerSpy = nil
        useCaseStub = nil
        throttlerSpy = nil
        viewModel = nil
        super.tearDown()
    }

    func testLoadCharactersWithSearchQuery() {
        // Given
        let query = "ANY"
        let results = MarvelCharacter.items()
        let items = results.map(CharacterViewItem.init)
        useCaseStub.promise = .init { Paginator.value(results: results) }

        // When
        viewModel.loadCharecters(with: query)

        // Then
        XCTAssertEqual(viewModel.state.value, .loading)
        XCTAssertEqual(viewModel.query, query.lowercased())

        // When
        throttlerSpy.completion()

        // Then
        XCTAssert(waitForPromises(timeout: 10.0))
        XCTAssertEqual(throttlerSpy.callCount, 1)
        XCTAssertEqual(viewModel.state.value.items, items)

        // When
        viewModel.loadCharecters()

        // Then
        XCTAssert(waitForPromises(timeout: 10.0))
        XCTAssertEqual(viewModel.state.value, .idle)
        XCTAssertEqual(viewModel.query, query.lowercased())
    }

    func testLoadCharactersWithPaginationSuccess() {
        // Given
        let total = 40
        let count = 20
        let totalResults = MarvelCharacter.items(numberOfElements: total)
        let totalItems = totalResults.map(CharacterViewItem.init)
        let initialResults = Array(totalResults.prefix(count))
        let initialPaginator = Paginator.value(total: total, results: initialResults)
        let initalItems = initialResults.map(CharacterViewItem.init)
        let initalState: State<CharacterViewItem> = .paging(initalItems, next: initialPaginator.nextOffset)
        useCaseStub.promise = .init { initialPaginator }

        XCTAssertTrue(viewModel.shouldLoadCharecters)

        // When
        viewModel.loadCharecters(at: .zero)

        // Then
        XCTAssertFalse(viewModel.shouldLoadCharecters)
        XCTAssert(waitForPromises(timeout: 10.0))
        XCTAssertEqual(viewModel.state.value, initalState)
        XCTAssertTrue(viewModel.shouldLoadCharecters)

        // Given
        let nextResults = Array(totalResults.suffix(count))
        let nextPaginator = initialPaginator.next(with: nextResults)
        let nextState: State<CharacterViewItem> = .populated(totalItems)
        useCaseStub.promise = .init { nextPaginator }

        // When
        viewModel.loadCharecters(at: nextState.nextPage)

        // Then
        XCTAssertFalse(viewModel.shouldLoadCharecters)
        XCTAssert(waitForPromises(timeout: 10.0))
        XCTAssertEqual(viewModel.state.value, nextState)
        XCTAssertTrue(viewModel.shouldLoadCharecters)
    }

    func testLoadCharactersWithPaginationFailed() {
        // Given
        let error = MarvelError.general
        let state: State<CharacterViewItem> = .error(error)
        useCaseStub.promise = .init(error)

        // When
        viewModel.loadCharecters(at: .zero)

        // Then
        XCTAssert(waitForPromises(timeout: 10.0))
        XCTAssertEqual(viewModel.state.value, state)
    }

    func testDidSelectRowAtIndexPath() {
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        let results = MarvelCharacter.items()
        let items = results.map(CharacterViewItem.init)
        useCaseStub.promise = .init { Paginator.value(results: results) }

        // When
        viewModel.loadCharecters(at: 0)
        XCTAssert(waitForPromises(timeout: 10.0))
        viewModel.didSelectRow(at: indexPath)

        // Then
        XCTAssertEqual(routerSpy.showDetailsCallCount, 1)
        XCTAssertEqual(routerSpy.character, items[indexPath.row])
    }

    func testDidTapSearch() {
        viewModel.didTapSearch()
        XCTAssertEqual(routerSpy.showSearchCallCount, 1)
    }

    func testDidTapCancelSearch() {
        viewModel.didTapCancelSearch()
        XCTAssertEqual(routerSpy.dismissSearchCallCount, 1)
    }
}
