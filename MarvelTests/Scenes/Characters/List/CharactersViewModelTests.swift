//
//  CharactersViewModelTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Combine
import CombineSchedulers
@testable import Marvel
import XCTest

final class CharactersViewModelTests: XCTestCase {
    var routerSpy: CharactersListRouterSpy!
    var useCaseStub: CharacterUseCaseStub!
    let scheduler = DispatchQueue.test
    var viewModel: CharactersViewModel!
    var cancellable: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        routerSpy = .init()
        useCaseStub = .init()
        viewModel = .init(
            router: routerSpy,
            useCase: useCaseStub,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        cancellable = .init()
    }

    override func tearDown() {
        routerSpy = nil
        useCaseStub = nil
        viewModel = nil
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        super.tearDown()
    }

    func testLoadCharactersWithSearch() {
        // Given
        var query = ""
        let results = MarvelCharacter.items()
        let paginator = Paginator.value(results: results)
        let items = results.map(CharacterItem.init)
        var states = [State<CharacterItem>]()
        useCaseStub.publisher = .just(.success(paginator))

        // When
        let searchSubject = PassthroughSubject<String, Never>()
        let output = makeOutput(search: searchSubject.eraseToAnyPublisher())

        // Then
        XCTAssertEqual(states, [])
        output.sink { states.append($0) }.store(in: &cancellable)
        searchSubject.send(query)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(states, [.idle])
        XCTAssertEqual(useCaseStub.callCount, 0)

        // When
        query = "ANY"
        searchSubject.send(query)
        scheduler.advance(by: .milliseconds(500))

        // Then
        XCTAssertEqual(useCaseStub.callCount, 1)
        XCTAssertEqual(useCaseStub.parameter.nameStartsWith, query.lowercased())
        XCTAssertEqual(states, [.idle, .loading, .populated(items)])
    }

    func testLoadCharactersPagination() {
        // Given
        let total = 40
        let limit = 20
        let results = MarvelCharacter.items(numberOfElements: total)
        let allItems = results.map(CharacterItem.init)
        var states = [State<CharacterItem>]()
        let initialResults = Array(results.prefix(limit))
        let initialPaginator = Paginator.value(total: total, results: initialResults)
        let initialItems = initialResults.map(CharacterItem.init)
        let pagingState: State<CharacterItem> = .paging(initialItems, next: initialPaginator.nextOffset)
        useCaseStub.publisher = .just(.success(initialPaginator))

        // When
        let nextPageSubject = PassthroughSubject<Int, Never>()
        let output = makeOutput(
            viewDidLoad: .just,
            nextPage: nextPageSubject.eraseToAnyPublisher()
        )

        // Then
        XCTAssertEqual(states, [])
        output.sink { states.append($0) }.store(in: &cancellable)
        XCTAssertEqual(useCaseStub.parameter.offset, initialPaginator.offset)
        XCTAssertEqual(useCaseStub.callCount, 1)
        XCTAssertEqual(states, [.loading, pagingState])

        // Given
        let nextResults = Array(results.suffix(limit))
        let nextPaginator = initialPaginator.next(with: nextResults)
        let populatedState: State<CharacterItem> = .populated(allItems)
        useCaseStub.publisher = .just(.success(nextPaginator))

        // When
        nextPageSubject.send(nextPaginator.offset)

        // Then
        XCTAssertEqual(useCaseStub.parameter.offset, nextPaginator.offset)
        XCTAssertEqual(useCaseStub.callCount, 2)
        XCTAssertEqual(states, [.loading, pagingState, populatedState])
    }

    func testLoadCharactersFailed() {
        // Given
        let error = MarvelError.general
        var states = [State<CharacterItem>]()
        useCaseStub.publisher = .just(.failure(error))

        // When
        let output = makeOutput(viewDidLoad: .just)

        // Then
        XCTAssertEqual(states, [])
        output.sink { states.append($0) }.store(in: &cancellable)
        XCTAssertEqual(states, [.loading, .error(error)])
    }

    func testDidSelectRowAtIndexPath() {
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        let results = MarvelCharacter.items()
        let paginator = Paginator.value(results: results)
        let items = results.map(CharacterItem.init)
        let item = items[indexPath.row]
        useCaseStub.publisher = .just(.success(paginator))

        // When
        let didSelectRow = PassthroughSubject<IndexPath, Never>()
        let output = makeOutput(viewDidLoad: .just, didSelectRow: didSelectRow.eraseToAnyPublisher())
        output.sink { _ in }.store(in: &cancellable)
        didSelectRow.send(indexPath)

        // Then
        XCTAssertEqual(routerSpy.showDetailsCallCount, 1)
        XCTAssertEqual(routerSpy.character, item)
    }

    func testDidTapSearch() {
        // When
        makeOutput(didTapSearch: .just)

        // Then
        XCTAssertEqual(routerSpy.showSearchCallCount, 1)
    }

    func testDidTapCancelSearch() {
        // When
        makeOutput(didDismissSearch: .just)

        // Then
        XCTAssertEqual(routerSpy.dismissSearchCallCount, 1)
    }
}

private extension CharactersViewModelTests {
    @discardableResult
    func makeOutput(
        viewDidLoad: AnyPublisher<Void, Never> = .empty,
        nextPage: AnyPublisher<Int, Never> = .empty,
        didSelectRow: AnyPublisher<IndexPath, Never> = .empty,
        search: AnyPublisher<String, Never> = .empty,
        didTapSearch: AnyPublisher<Void, Never> = .empty,
        didDismissSearch: AnyPublisher<Void, Never> = .empty
    ) -> CharactersViewModel.Output {
        let input = CharactersViewModel.Input(
            viewDidLoad: viewDidLoad,
            nextPage: nextPage,
            didSelectRow: didSelectRow,
            search: search,
            didTapSearch: didTapSearch,
            didDismissSearch: didDismissSearch
        )

        return viewModel.transform(input: input)
    }
}
