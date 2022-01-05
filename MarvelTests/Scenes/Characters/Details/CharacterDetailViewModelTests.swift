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
        let output = viewModel.transform(input: .init(viewDidLoad: .just))

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
        let items = allCases.map { CharacterDetailsItem(type: $0, state: .populated(mediaItems)) }
        var states = [State<CharacterDetailsItem>]()

        useCaseStub.publisher = .just(.success(paginator))

        // When
        let output = viewModel.transform(input: .init(viewDidLoad: .just))

        // Then
        XCTAssertEqual(states, [])
        output.state.sink { states.append($0) }.store(in: &cancellable)
        XCTAssertEqual(useCaseStub.parameter.id, characterItem.model.id)
        XCTAssertEqual(useCaseStub.parameter.type, allCases.last)
        XCTAssertEqual(useCaseStub.callCount, numberOfElements)
        XCTAssertEqual(states, [.loading, .populated(items)])
    }

    func testLoadItemsFailed() {
        // Given
        let error = MarvelError.general
        let items = MediaType.allCases.map { CharacterDetailsItem(type: $0, state: .error(error)) }
        var states = [State<CharacterDetailsItem>]()
        useCaseStub.publisher = .just(.failure(error))

        // When
        let output = viewModel.transform(input: .init(viewDidLoad: .just))

        // Then
        XCTAssertEqual(states, [])
        output.state.sink { states.append($0) }.store(in: &cancellable)
        XCTAssertEqual(states, [.loading, .populated(items)])
    }
}
