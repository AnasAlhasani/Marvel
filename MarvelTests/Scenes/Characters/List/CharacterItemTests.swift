//
//  CharacterItemTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 16/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

@testable import Marvel
import XCTest

final class CharacterItemTests: XCTestCase {
    func testItemWhenFieldsAreNotNil() {
        let model = MarvelCharacter.item(index: 0)
        let item = CharacterItem(model)

        XCTAssertEqual(item.model, model)
        XCTAssertEqual(item.imageURL, model.thumbnail?.url)
        XCTAssertEqual(item.nameTitle, L10n.Character.name)
        XCTAssertEqual(item.name, model.name)
        XCTAssertEqual(item.descriptionTitle, L10n.Character.description)
        XCTAssertEqual(item.description, model.description)
    }

    func testItemWhenFieldsAreNil() {
        let model = MarvelCharacter(
            id: .init(rawValue: 0),
            name: nil,
            description: nil,
            thumbnail: nil
        )
        let item = CharacterItem(model)

        XCTAssertEqual(item.model, model)
        XCTAssertEqual(item.nameTitle, L10n.Character.name)
        XCTAssertEqual(item.name, L10n.Common.notAvailable)
        XCTAssertEqual(item.descriptionTitle, L10n.Character.description)
        XCTAssertEqual(item.description, L10n.Common.notAvailable)
        XCTAssertNil(item.imageURL)
    }
}
