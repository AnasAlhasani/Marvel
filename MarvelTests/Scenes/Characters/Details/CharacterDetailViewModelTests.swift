//
//  CharacterDetailViewModelTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 16/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

@testable import Marvel
import XCTest

final class CharacterDetailViewModelTests: XCTestCase {
    var useCaseStub: MediaUseCaseStub!
    var characterItem: CharacterItem!
    var viewModel: CharacterDetailViewModel!

    override func setUp() {
        super.setUp()
        useCaseStub = .init()
        characterItem = .init(.item(index: 0))
        viewModel = .init(
            mediaUseCase: useCaseStub,
            character: characterItem
        )
    }

    override func tearDown() {
        useCaseStub = nil
        characterItem = nil
        viewModel = nil
        super.tearDown()
    }

    func testInitStateValues() {
        let items: [CharacterDetailsItem] = [.init(type: .comics), .init(type: .series)]
        XCTAssertEqual(viewModel.comicsItem.state, .loading)
        XCTAssertEqual(viewModel.seriesItem.state, .loading)
        XCTAssertEqual(viewModel.state.value, .populated(items))
    }

    func testLoadItemsSuccessfully() {
        // Given
        let numberOfElements = MediaType.allCases.count
        let results = Media.items(numberOfElements: numberOfElements)
        let mediaItems = results.map(CharacterDetailsItem.MediaItem.init)
        let detailsItems = MediaType.allCases.map {
            CharacterDetailsItem(type: $0, state: .populated(mediaItems))
        }
        let state: State<CharacterDetailsItem> = .populated(detailsItems)
        useCaseStub.publisher = .just(Paginator.value(results: results))

        // When
        viewModel.loadItems()

        // Then
        XCTAssertEqual(useCaseStub.callCount, numberOfElements)
        XCTAssertEqual(viewModel.state.value, state)
    }

    func testLoadItemsFailed() {
        // Given
        let error = MarvelError.general
        let state: State<CharacterDetailsItem> = .error(error)
        useCaseStub.publisher = .fail(with: error)

        // When
        viewModel.loadItems()

        // Then
        XCTAssertEqual(viewModel.state.value, state)
    }
}
