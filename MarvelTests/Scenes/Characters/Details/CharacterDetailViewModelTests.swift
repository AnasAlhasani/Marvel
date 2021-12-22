//
//  CharacterDetailViewModelTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 16/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Combine
@testable import Marvel
import XCTest

final class CharacterDetailViewModelTests: XCTestCase {
    var useCaseStub: MediaUseCaseStub!
    var characterItem: CharacterItem!
    var cancellable: Set<AnyCancellable>!
    var viewModel: CharacterDetailViewModel!

    override func setUp() {
        super.setUp()
        useCaseStub = .init()
        characterItem = .init(.item(index: 0))
        cancellable = .init()
        viewModel = .init(
            useCase: useCaseStub,
            character: characterItem
        )
    }

    override func tearDown() {
        useCaseStub = nil
        characterItem = nil
        viewModel = nil
        cancellable = nil
        super.tearDown()
    }

    func testCharacterItem() {
        // Given
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let output = makeOutput(viewDidLoad: viewDidLoad)

        // When
        viewDidLoad.send()

        // Then
        output
            .character
            .sink { [unowned self] in XCTAssertEqual($0, characterItem) }
            .store(in: &cancellable)
    }

    func testLoadItemsSuccessfully() {
        // Given
        let numberOfElements = MediaType.allCases.count
        let results = Media.items(numberOfElements: numberOfElements)
        let paginator = Paginator.value(results: results)
        let allCases = MediaType.allCases
        let mediaItems = results.map(CharacterDetailsItem.MediaItem.init)
        let detailItems = allCases.map { CharacterDetailsItem(type: $0, state: .populated(mediaItems)) }
        let state: State<CharacterDetailsItem> = .populated(detailItems)

        let viewDidLoad = PassthroughSubject<Void, Never>()
        let output = makeOutput(viewDidLoad: viewDidLoad)

        useCaseStub.publisher = .just(.success(paginator))

        // When
        viewDidLoad.send()

        // Then
        output.state.sink { [unowned self] in
            XCTAssertEqual(self.useCaseStub.callCount, numberOfElements)
            XCTAssertEqual(self.useCaseStub.parameter.id, characterItem.model.id)
            XCTAssertEqual(self.useCaseStub.parameter.type, allCases.last)
            XCTAssertEqual($0, state)
        }.store(in: &cancellable)
    }

    func testLoadItemsFailed() {
        // Given
        let error = MarvelError.general
        let state: State<CharacterDetailsItem.MediaItem> = .error(error)

        let viewDidLoad = PassthroughSubject<Void, Never>()
        let output = makeOutput(viewDidLoad: viewDidLoad)

        useCaseStub.publisher = .just(.failure(error))

        // When
        viewDidLoad.send()

        // Then
        output.state
            .map(\.items)
            .eraseToAnyPublisher()
            .sink { $0.forEach { XCTAssertEqual($0.state, state) } }
            .store(in: &cancellable)
    }
}

private extension CharacterDetailViewModelTests {
    func makeOutput(
        viewDidLoad: PassthroughSubject<Void, Never> = .init()
    ) -> CharacterDetailViewModel.Output {
        viewModel.transform(input: .init(viewDidLoad: viewDidLoad.eraseToAnyPublisher()))
    }
}
