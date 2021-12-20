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
        makeOutput()
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
        useCaseStub.publisher = .just(.success(paginator))

        // When
        let output = makeOutput()

        // Then
        output.state.sink { XCTAssertEqual($0, state) }.store(in: &cancellable)
        XCTAssertEqual(useCaseStub.callCount, numberOfElements)
        XCTAssertEqual(useCaseStub.parameter.id, characterItem.model.id)
        XCTAssertEqual(useCaseStub.parameter.type, allCases.last)
    }

    func testLoadItemsFailed() {
        // Given
        let error = MarvelError.general
        let state: State<CharacterDetailsItem.MediaItem> = .error(error)
        useCaseStub.publisher = .just(.failure(error))

        // When
        let output = makeOutput()

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
        viewDidLoad: AnyPublisher<Void, Never> = .passthroughSubject
    ) -> CharacterDetailViewModel.Output {
        let input = CharacterDetailViewModel.Input(viewDidLoad: viewDidLoad)
        return viewModel.transform(input: input)
    }
}
