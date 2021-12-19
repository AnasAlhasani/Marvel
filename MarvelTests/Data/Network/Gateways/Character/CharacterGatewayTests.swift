//
//  CharacterGatewayTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 13/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation
@testable import Marvel
import XCTest

final class CharacterGatewayTests: XCTestCase {
    var apiClientSpy: APIClientSpy<MarvelCharacter>!
    var characterGateway: CharacterGateway!

    override func setUp() {
        apiClientSpy = .init()
        characterGateway = APICharacterGateway(apiClient: apiClientSpy)
    }

    override func tearDown() {
        apiClientSpy = nil
        characterGateway = nil
        super.tearDown()
    }

    func testLoadCharactersWithSuccess() throws {
        // Given
        let results = MarvelCharacter.items()
        let paginator = Paginator.value(results: results)
        let parameter = MarvelParameter(CharacterParameter(offset: 0, query: "any"))
        apiClientSpy.promise = .init { MarvelResponse(data: paginator) }

        // When
        let publisher = characterGateway.loadCharacters(with: parameter)
        let result = try awaitPublisher(publisher)

        // Then
        XCTAssertEqual(apiClientSpy.request.path, "characters")
        XCTAssertEqual(apiClientSpy.request.method, .get)
        XCTAssertEqual(
            apiClientSpy.request.urlParameters,
            try? MarvelParameter(parameter).encoded()
        )
        XCTAssertEqual(try result.get(), paginator)
        XCTAssertNil(result.error)
    }

    func testLoadCharactersWithFailure() throws {
        // Given
        let error = MarvelError.general
        let parameter = MarvelParameter(CharacterParameter(offset: 0, query: "any"))
        apiClientSpy.promise = .init { MarvelResponse<MarvelCharacter>(message: error.message) }

        // When
        let publisher = characterGateway.loadCharacters(with: parameter)
        let result = try awaitPublisher(publisher)

        // Then
        XCTAssertNil(try? result.get())
        XCTAssertEqual(result.error as? MarvelError, error)
    }
}
