//
//  CharacterGatewayTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 13/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation
@testable import Marvel
@testable import Promises
import XCTest

final class CharacterGatewayTests: XCTestCase {
    var apiClientSpy: APIClientSpy<MarvelCharacter>!
    var characterGateway: CharacterGateway!

    override func setUp() {
        apiClientSpy = .init()
        characterGateway = .init(apiClient: apiClientSpy)
    }

    override func tearDown() {
        apiClientSpy = nil
        characterGateway = nil
        super.tearDown()
    }

    func testLoadCharactersWithSuccess() {
        // Given
        let results = MarvelCharacter.items()
        let paginator = Paginator.paginator(results: results)
        let parameter = MarvelParameter(CharacterParameter(query: "any"))
        apiClientSpy.promise = .init { MarvelResponse(data: paginator) }

        // When
        let promise = characterGateway.loadCharacters(with: parameter)

        // Then

        XCTAssert(waitForPromises(timeout: 1.0))
        XCTAssertEqual(apiClientSpy.request.path, "characters")
        XCTAssertEqual(apiClientSpy.request.method, .get)
        XCTAssertEqual(
            apiClientSpy.request.urlParameters,
            try? MarvelParameter(parameter).encoded()
        )
        XCTAssertEqual(promise.value, paginator)
        XCTAssertNil(promise.error)
    }

    func testLoadCharactersWithFailure() {
        // Given
        let error = MarvelError.general
        let parameter = MarvelParameter(CharacterParameter(query: "any"))
        apiClientSpy.promise = .init { MarvelResponse<MarvelCharacter>(message: error.message) }

        // When
        let promise = characterGateway.loadCharacters(with: parameter)

        // Then

        XCTAssert(waitForPromises(timeout: 1.0))

        XCTAssertNil(promise.value)
        XCTAssertEqual(promise.error as? MarvelError, error)
    }
}
