//
//  CharactersViewModelTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

@testable import Marvel
import XCTest

final class CharactersViewModelTests: XCTestCase {
    var routerSpy: CharactersListRouterSpy!
    var useCaseStub: CharacterUseCaseStub!
    var viewModel: CharactersViewModel!

    override func setUp() {
        super.setUp()
        routerSpy = .init()
        useCaseStub = .init()
        viewModel = .init(
            router: routerSpy,
            useCase: useCaseStub
        )
    }

    override func tearDown() {
        routerSpy = nil
        useCaseStub = nil
        viewModel = nil
        super.tearDown()
    }

    func testLoadCharactersWithSearchQuery() {
        // Given
        let query = "ANY"
        let results = MarvelCharacter.items()
        let items = results.map(CharacterItem.init)
        useCaseStub.publisher = .just(Paginator.value(results: results))

        // When
        viewModel.loadCharacters(with: query)

        // Then
        XCTAssertEqual(viewModel.state.value, .loading)
        XCTAssertEqual(viewModel.query, query.lowercased())

        // When
        throttlerSpy.completion()

        // Then
        XCTAssertEqual(throttlerSpy.callCount, 1)
        XCTAssertEqual(viewModel.state.value.items, items)

        // When
        viewModel.loadCharacters()

        // Then
        XCTAssertEqual(viewModel.state.value, .idle)
        XCTAssertEqual(viewModel.query, query.lowercased())
    }

    func testLoadCharactersWithPaginationSuccess() {
        // Given
        let total = 40
        let count = 20
        let totalResults = MarvelCharacter.items(numberOfElements: total)
        let totalItems = totalResults.map(CharacterItem.init)
        let initialResults = Array(totalResults.prefix(count))
        let initialPaginator = Paginator.value(total: total, results: initialResults)
        let initalItems = initialResults.map(CharacterItem.init)
        let initalState: State<CharacterItem> = .paging(initalItems, next: initialPaginator.nextOffset)
        useCaseStub.publisher = .just(initialPaginator)

        XCTAssertTrue(viewModel.shouldLoadCharacters)

        // When
        viewModel.loadCharacters(at: .zero)

        // Then
        XCTAssertEqual(viewModel.state.value, initalState)
        XCTAssertTrue(viewModel.shouldLoadCharacters)

        // Given
        let nextResults = Array(totalResults.suffix(count))
        let nextPaginator = initialPaginator.next(with: nextResults)
        let nextState: State<CharacterItem> = .populated(totalItems)
        useCaseStub.publisher = .just(nextPaginator)

        // When
        viewModel.loadCharacters(at: nextState.nextPage)

        // Then
        XCTAssertEqual(viewModel.state.value, nextState)
        XCTAssertTrue(viewModel.shouldLoadCharacters)
    }

    func testLoadCharactersWithPaginationFailed() {
        // Given
        let error = MarvelError.general
        let state: State<CharacterItem> = .error(error)
        useCaseStub.publisher = .fail(with: error)

        // When
        viewModel.loadCharacters(at: .zero)

        // Then
        XCTAssertEqual(viewModel.state.value, state)
    }

    func testDidSelectRowAtIndexPath() {
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        let results = MarvelCharacter.items()
        let items = results.map(CharacterItem.init)
        useCaseStub.publisher = .just(Paginator.value(results: results))

        // When
        viewModel.loadCharacters(at: 0)
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
