//
//  CharacterDetailViewModelTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 16/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

@testable import Marvel
@testable import Promises
import XCTest

final class CharacterDetailViewModelTests: XCTestCase {
    var useCaseStub: MediaUseCaseStub!
    var characterItem: CharacterViewItem!
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
        let items: [CharacterDetailsViewItem] = [.init(type: .comics), .init(type: .series)]
        XCTAssertEqual(viewModel.comicsItem.state, .loading)
        XCTAssertEqual(viewModel.seriesItem.state, .loading)
        XCTAssertEqual(viewModel.state.value, .populated(items))
    }

    func testLoadItemsSuccessfully() {
        // Given
        let numberOfElements = MediaType.allCases.count
        let results = Media.items(numberOfElements: numberOfElements)
        let mediaItems = results.map(CharacterDetailsViewItem.MediaItem.init)
        let detailsItems = MediaType.allCases.map {
            CharacterDetailsViewItem(type: $0, state: .populated(mediaItems))
        }
        let state: State<CharacterDetailsViewItem> = .populated(detailsItems)
        useCaseStub.promise = .init { Paginator.value(results: results) }

        // When
        viewModel.loadItems()

        // Then
        XCTAssert(waitForPromises(timeout: 10.0))
        XCTAssertEqual(useCaseStub.callCount, numberOfElements)
        XCTAssertEqual(viewModel.state.value, state)
    }

    func testLoadItemsFailed() {
        // Given
        let error = MarvelError.general
        let state: State<CharacterDetailsViewItem> = .error(error)
        useCaseStub.promise = .init(error)

        // When
        viewModel.loadItems()

        // Then
        XCTAssert(waitForPromises(timeout: 10.0))
        XCTAssertEqual(viewModel.state.value, state)
    }
}
