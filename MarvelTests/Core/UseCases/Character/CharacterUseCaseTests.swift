//
//  CharacterUseCaseTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

@testable import Marvel
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

    func testLoadCharacters() throws {
        // Given
        let results = MarvelCharacter.items()
        let paginator = Paginator.value(results: results)
        let parameter = CharacterParameter(query: "any")
        gatewayStub.publisher = .just(paginator)
        repositroyStub.savePublisher = .just(())

        // When
        let publisher = useCase.loadCharacters(with: parameter)
        let result = try awaits(for: publisher)

        // Then
        XCTAssertEqual(gatewayStub.callCount, 1)
        XCTAssertEqual(gatewayStub.publisher.value, paginator)
        XCTAssertNil(gatewayStub.publisher.error)

        XCTAssertEqual(repositroyStub.entites, results)
        XCTAssertEqual(repositroyStub.saveCallCount, 1)
        XCTAssertTrue(repositroyStub.savePublisher.value! == ())
        XCTAssertNil(repositroyStub.savePublisher.error)

        XCTAssertEqual(try result.get(), paginator)
        XCTAssertNil(result.error)
    }

    func testLoadCharactersWithRecoverWhenAPIFails() throws {
        // Given
        let error = MarvelError.general
        let results = MarvelCharacter.items()
        let paginator = Paginator.value(offset: 0, limit: 0, total: 0, count: 0, results: results)
        let parameter = CharacterParameter(query: "any")
        gatewayStub.publisher = .fail(with: error)
        repositroyStub.savePublisher = .just(())
        repositroyStub.fetchPublisher = .just(results)

        // When
        let publisher = useCase.loadCharacters(with: parameter)
        let result = try awaits(for: publisher)

        // Then
        XCTAssertEqual(gatewayStub.callCount, 1)
        XCTAssertNil(gatewayStub.publisher.value)
        XCTAssertEqual(gatewayStub.publisher.error as? MarvelError, error)

        XCTAssertEqual(repositroyStub.fetchCallCount, 1)
        XCTAssertEqual(repositroyStub.fetchPublisher.value, results)
        XCTAssertNil(repositroyStub.fetchPublisher.error)

        XCTAssertEqual(try result.get(), paginator)
        XCTAssertNil(result.error)
    }
}
