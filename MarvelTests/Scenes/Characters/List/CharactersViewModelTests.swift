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
    var cancellable = Set<AnyCancellable>()

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

    func testLoadCharactersWithSearch() {
        // Given
        var query = ""
        let results = MarvelCharacter.items()
        let paginator = Paginator.value(results: results)
        let items = results.map(CharacterItem.init)

        let viewDidLoad = PassthroughSubject<Void, Never>()
        let search = PassthroughSubject<String, Never>()
        let nextPage = PassthroughSubject<Int, Never>()
        let output = makeOutput(viewDidLoad: viewDidLoad, nextPage: nextPage, search: search)
        useCaseStub.publisher = .just(.success(paginator))

        // When
        viewDidLoad.send()
        search.send(query)
        nextPage.send(.zero)

        // Then
        output.sink {
            XCTAssertEqual(self.useCaseStub.callCount, .zero)
            XCTAssertEqual(self.useCaseStub.parameter.offset, .zero)
            XCTAssertNil(self.useCaseStub.parameter.nameStartsWith)
            XCTAssertEqual($0, .idle)
        }.store(in: &cancellable)

        // When
        query = "ANY"
        search.send(query)
        nextPage.send(1)

        // Then
        output.sink { [unowned self] in
            XCTAssertEqual(self.useCaseStub.callCount, 2)
            XCTAssertEqual(self.useCaseStub.parameter.offset, 1)
            XCTAssertEqual(self.useCaseStub.parameter.nameStartsWith, query.lowercased())
            XCTAssertEqual($0, .populated(items))
        }.store(in: &cancellable)
    }

    func testLoadCharactersPaginationWithSearch() {
        // Given
        let total = 40
        let count = 20
        let totalResults = MarvelCharacter.items(numberOfElements: total)
        let totalItems = totalResults.map(CharacterItem.init)
        let initialResults = Array(totalResults.prefix(count))
        let initialPaginator = Paginator.value(total: total, results: initialResults)
        let initialItems = initialResults.map(CharacterItem.init)
        let initialState: State<CharacterItem> = .paging(initialItems, next: initialPaginator.nextOffset)

        let viewDidLoad = PassthroughSubject<Void, Never>()
        let nextPage = PassthroughSubject<Int, Never>()
        let output = makeOutput(viewDidLoad: viewDidLoad, nextPage: nextPage)

        useCaseStub.publisher = .just(.success(initialPaginator))

        // When
        viewDidLoad.send()
        nextPage.send(.zero)

        // Then
        output.sink { [unowned self] in
            XCTAssertEqual(self.useCaseStub.parameter.offset, .zero)
            XCTAssertEqual(self.useCaseStub.callCount, 1)
            XCTAssertEqual($0, initialState)
        }.store(in: &cancellable)

        // Given
        let nextResults = Array(totalResults.suffix(count))
        let nextPaginator = initialPaginator.next(with: nextResults)
        let nextState: State<CharacterItem> = .populated(totalItems)
        useCaseStub.publisher = .just(.success(nextPaginator))

        // When
        nextPage.send(nextState.nextPage)

        // Then
        output.sink { [unowned self] in
            XCTAssertEqual(self.useCaseStub.parameter.offset, nextState.nextPage)
            XCTAssertEqual(self.useCaseStub.callCount, 2)
            XCTAssertEqual($0, nextState)
        }.store(in: &cancellable)
    }

    func testLoadCharactersFailed() throws {
        // Given
        let error = MarvelError.general
        let state: State<CharacterItem> = .error(error)

        let viewDidLoad = PassthroughSubject<Void, Never>()
        let output = makeOutput(viewDidLoad: viewDidLoad)

        useCaseStub.publisher = .just(.failure(error))

        // When
        viewDidLoad.send()

        // Then
        output.sink {
            XCTAssertEqual($0, state)

        }.store(in: &cancellable)
    }

    func testDidSelectRowAtIndexPath() {
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        let results = MarvelCharacter.items()
        let paginator = Paginator.value(results: results)
        let items = results.map(CharacterItem.init)
        let item = items[indexPath.row]

        let didSelectRow = PassthroughSubject<CharacterItem, Never>()
        makeOutput(didSelectRow: didSelectRow)

        useCaseStub.publisher = .just(.success(paginator))

        // When
        didSelectRow.send(item)

        // Then
        XCTAssertEqual(routerSpy.showDetailsCallCount, 1)
        XCTAssertEqual(routerSpy.character, items[indexPath.row])
    }

    func testDidTapSearch() {
        // Given
        let subject = PassthroughSubject<Void, Never>()
        makeOutput(didTapSearch: subject)

        // When
        subject.send()

        // Then
        XCTAssertEqual(routerSpy.showSearchCallCount, 1)
    }

    func testDidTapCancelSearch() {
        // Given
        let subject = PassthroughSubject<Void, Never>()
        makeOutput(didDismissSearch: subject)

        // When
        subject.send()

        // Then
        XCTAssertEqual(routerSpy.dismissSearchCallCount, 1)
    }
}

private extension CharactersViewModelTests {
    @discardableResult
    func makeOutput(
        viewDidLoad: PassthroughSubject<Void, Never> = .init(),
        nextPage: PassthroughSubject<Int, Never> = .init(),
        didSelectRow: PassthroughSubject<CharacterItem, Never> = .init(),
        search: PassthroughSubject<String, Never> = .init(),
        didTapSearch: PassthroughSubject<Void, Never> = .init(),
        didDismissSearch: PassthroughSubject<Void, Never> = .init()
    ) -> CharactersViewModel.Output {
        let input = CharactersViewModel.Input(
            viewDidLoad: viewDidLoad.eraseToAnyPublisher(),
            nextPage: nextPage.eraseToAnyPublisher(),
            didSelectRow: didSelectRow.eraseToAnyPublisher(),
            search: search.eraseToAnyPublisher(),
            didTapSearch: didTapSearch.eraseToAnyPublisher(),
            didDismissSearch: didDismissSearch.eraseToAnyPublisher()
        )

        return viewModel.transform(input: input)
    }
}
