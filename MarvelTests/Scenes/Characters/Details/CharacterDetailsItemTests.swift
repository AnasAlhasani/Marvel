//
//  CharacterDetailsItemTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 16/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

@testable import Marvel
import XCTest

final class CharacterDetailsItemTests: XCTestCase {
    func testComicItem() {
        let item = CharacterDetailsItem(type: .comics, state: .idle)

        XCTAssertEqual(item.type.title, L10n.Character.comics)
        XCTAssertEqual(item.state, .idle)
    }

    func testSeriesItem() {
        let item = CharacterDetailsItem(type: .series, state: .idle)

        XCTAssertEqual(item.type.title, L10n.Character.series)
        XCTAssertEqual(item.state, .idle)
    }

    func testMediaItemWhenFieldsAreNotNil() {
        let model = Media.item(index: 0)
        let item = CharacterDetailsItem.MediaItem(model: model)

        XCTAssertEqual(item.model, model)
        XCTAssertEqual(item.title, model.title)
        XCTAssertEqual(item.imageURL, model.thumbnail?.url)
    }

    func testMediaItemWhenFieldsAreNil() {
        let model = Media(id: .init(rawValue: 0), title: nil, thumbnail: nil)
        let item = CharacterDetailsItem.MediaItem(model: model)

        XCTAssertEqual(item.model, model)
        XCTAssertEqual(item.title, L10n.Common.notAvailable)
        XCTAssertNil(item.imageURL)
    }

    func testMediaTypePosition() {
        XCTAssertTrue(MediaType.comics.isHigherThan(.series))
        XCTAssertFalse(MediaType.series.isHigherThan(.comics))
    }
}
