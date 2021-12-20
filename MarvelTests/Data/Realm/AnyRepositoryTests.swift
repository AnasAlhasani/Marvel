//
//  AnyRepositoryTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

@testable import Marvel
import XCTest

final class AnyRepositoryTests: XCTestCase {
    var spy: RealmRepositorySpy<EntityTestDouble>!
    var repository: AnyRepository<EntityTestDouble>!

    override func setUp() {
        spy = .init()
        repository = .init(spy)
    }

    override func tearDown() {
        spy = nil
        repository = nil
        super.tearDown()
    }

    func testSaveEntitiesWithSuccess() throws {
        // Given
        let entities = EntityTestDouble.items()
        spy.savePublisher = .just(())

        // When
        let publisher = repository.save(entities: entities)
        let result = try awaitPublisher(publisher)

        // Then
        XCTAssertTrue(try result.get() == ())
        XCTAssertNil(result.error)
        XCTAssertEqual(spy.entities, entities)
        XCTAssertEqual(spy.saveCallCount, 1)
    }

    func testSaveEntitiesWithFailure() throws {
        // Given
        let entities = EntityTestDouble.items()
        let error = MarvelError.general
        spy.savePublisher = .fail(with: error)

        // When
        let publisher = repository.save(entities: entities)
        let result = try awaitPublisher(publisher)

        // Then
        XCTAssertEqual(result.error as? MarvelError, error)
        XCTAssertEqual(spy.entities, entities)
        XCTAssertEqual(spy.saveCallCount, 1)
    }

    func testFetchAllWithSuccess() throws {
        // Given
        let entities = EntityTestDouble.items()
        spy.fetchPublisher = .just(entities)

        // When
        let publisher = repository.fetchAll()
        let result = try awaitPublisher(publisher)

        // Then
        XCTAssertEqual(try result.get(), entities)
        XCTAssertNil(result.error)
        XCTAssertEqual(spy.fetchCallCount, 1)
    }

    func testFetchAllWithFailure() throws {
        // Given
        let error = MarvelError.general
        spy.fetchPublisher = .fail(with: error)

        // When
        let publisher = repository.fetchAll()
        let result = try awaitPublisher(publisher)

        // Then
        XCTAssertNil(try? result.get())
        XCTAssertEqual(result.error as? MarvelError, error)
        XCTAssertEqual(spy.fetchCallCount, 1)
    }
}
