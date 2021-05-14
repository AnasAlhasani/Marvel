//
//  CharacterUseCaseTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

@testable import Marvel
@testable import Promises
import XCTest

final class CharacterUseCaseTests: XCTestCase {
    var repositroyStub: RepositoryStub<MarvelCharacter>!
    var gatewayStub: CharacterGatewayStub!
    var useCase: CharacterUseCase!

    override func setUp() {
        super.setUp()
        repositroyStub = .init()
        gatewayStub = .init()
        useCase = DefaultCharacterUseCase(
            gateway: gatewayStub,
            repository: repositroyStub.eraseToAnyRepository()
        )
    }

    override func tearDown() {
        repositroyStub = nil
        gatewayStub = nil
        useCase = nil
        super.tearDown()
    }

    func testLoadCharacters() {
        // Given
        let results = MarvelCharacter.items()
        let paginator = Paginator.paginator(results: results)
        let parameter = CharacterParameter(query: "any")
        gatewayStub.promise = .init { paginator }
        repositroyStub.savePromise = .init {}

        // When
        let promise = useCase.loadCharacters(with: parameter)

        // Then
        XCTAssert(waitForPromises(timeout: 1.0))

        // XCTAssertEqual(gatewayStub.parameter, .init(parameter))
        XCTAssertEqual(gatewayStub.callCount, 1)
        XCTAssertEqual(gatewayStub.promise.value, paginator)
        XCTAssertNil(gatewayStub.promise.error)

        XCTAssertEqual(repositroyStub.entites, results)
        XCTAssertEqual(repositroyStub.saveCallCount, 1)
        XCTAssertTrue(repositroyStub.savePromise.value == ())
        XCTAssertNil(repositroyStub.savePromise.error)

        XCTAssertEqual(promise.value, paginator)
        XCTAssertNil(promise.error)
    }

    func testLoadCharactersWithRecoverWhenAPIFails() {
        // Given
        let error = MarvelError.general
        let results = MarvelCharacter.items()
        let paginator = Paginator.paginator(results: results)
        let parameter = CharacterParameter(query: "any")
        gatewayStub.promise = .init(error)
        repositroyStub.savePromise = .init {}
        repositroyStub.fetchPromise = .init { results }

        // When
        let promise = useCase.loadCharacters(with: parameter)

        // Then
        XCTAssert(waitForPromises(timeout: 1.0))

        XCTAssertEqual(gatewayStub.callCount, 1)
        XCTAssertNil(gatewayStub.promise.value)
        XCTAssertEqual(gatewayStub.promise.error as? MarvelError, error)

        XCTAssertEqual(repositroyStub.fetchCallCount, 1)
        XCTAssertEqual(repositroyStub.fetchPromise.value, results)
        XCTAssertNil(repositroyStub.fetchPromise.error)

        XCTAssertEqual(promise.value, paginator)
        XCTAssertNil(promise.error)
    }
}
