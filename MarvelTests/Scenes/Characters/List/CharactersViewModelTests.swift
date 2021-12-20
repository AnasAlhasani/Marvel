//
//  CharactersViewModelTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//
import Combine
@testable import Marvel
import XCTest

final class CharactersViewModelTests: XCTestCase {
    var routerSpy: CharactersListRouterSpy!
    var useCaseStub: CharacterUseCaseStub!
    var viewModel: CharactersViewModel!
    var cancellable: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        routerSpy = .init()
        useCaseStub = .init()
        cancellable = .init()
        viewModel = .init(
            router: routerSpy,
            useCase: useCaseStub
        )
    }

    override func tearDown() {
        routerSpy = nil
        useCaseStub = nil
        viewModel = nil
        cancellable = nil
        super.tearDown()
    }

    func testLoadCharactersWithSearchQuery() {
        /*
         // Given
         let query = "ANY"
         let results = MarvelCharacter.items()
         let paginator = Paginator.value(results: results)
         let items = results.map(CharacterItem.init)
         useCaseStub.publisher = .just(.success(paginator))

         // When
         let output = makeOutput(search: .just(query))

         // Then
         output.sink { XCTAssertEqual($0, .loading) }.store(in: &cancellable)
         XCTAssertEqual(useCaseStub.parameter.nameStartsWith, query.lowercased())

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
         */
    }

    func testLoadCharactersPagination() {
        /*
         // Given
         let total = 40
         let count = 20
         let totalResults = MarvelCharacter.items(numberOfElements: total)
         let totalItems = totalResults.map(CharacterItem.init)
         let initialResults = Array(totalResults.prefix(count))
         let initialPaginator = Paginator.value(total: total, results: initialResults)
         let initialItems = initialResults.map(CharacterItem.init)
         let initialState: State<CharacterItem> = .paging(initialItems, next: initialPaginator.nextOffset)
         useCaseStub.publisher = .just(.success(initialPaginator))

         // When
         let initialOutput = makeOutput(viewDidLoad: .just(), nextPage: .just(.zero))

         // Then
         initialOutput.sink { XCTAssertEqual($0, initialState) }.store(in: &cancellable)

         // Given
         let nextResults = Array(totalResults.suffix(count))
         let nextPaginator = initialPaginator.next(with: nextResults)
         let nextState: State<CharacterItem> = .populated(totalItems)
         useCaseStub.publisher = .just(.success(nextPaginator))

         // When
         let nextOutput = makeOutput(nextPage: .just(nextState.nextPage))

         // Then
         nextOutput.sink { XCTAssertEqual($0, nextState) }.store(in: &cancellable)
         */
    }

    func testLoadCharactersFailed() throws {
        /*
         // Given
         let error = MarvelError.general
         let state: State<CharacterItem> = .error(error)
         useCaseStub.publisher = .just(.failure(error))

         // When
         let output = makeOutput(viewDidLoad: .just())

         // Then
         output.sink { XCTAssertEqual($0, state) }.store(in: &cancellable)
         */
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
        makeOutput(
            viewDidLoad: .just(),
            didSelectRow: .just(item)
        )

        // Then
        XCTAssertEqual(routerSpy.showDetailsCallCount, 1)
        XCTAssertEqual(routerSpy.character, items[indexPath.row])
    }

    func testDidTapSearch() {
        makeOutput(didTapSearch: .just())
        XCTAssertEqual(routerSpy.showSearchCallCount, 1)
    }

    func testDidTapCancelSearch() {
        makeOutput(didDismissSearch: .just())
        XCTAssertEqual(routerSpy.dismissSearchCallCount, 1)
    }
}

private extension CharactersViewModelTests {
    @discardableResult
    func makeOutput(
        viewDidLoad: AnyPublisher<Void, Never> = .passthroughSubject,
        nextPage: AnyPublisher<Int, Never> = .passthroughSubject,
        didSelectRow: AnyPublisher<CharacterItem, Never> = .passthroughSubject,
        search: AnyPublisher<String, Never> = .passthroughSubject,
        didTapSearch: AnyPublisher<Void, Never> = .passthroughSubject,
        didDismissSearch: AnyPublisher<Void, Never> = .passthroughSubject
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
