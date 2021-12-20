//
//  RealmRepositoryTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

@testable import Marvel
import RealmSwift
import XCTest

final class RealmRepositoryTests: XCTestCase {
    var repository: RealmRepository<EntityTestDouble>!

    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = name
        repository = .init()
    }

    override func tearDown() {
        repository = nil
        super.tearDown()
    }

    func testSaveEntitiesWithSuccess() throws {
        // Given
        let entities = EntityTestDouble.items()

        // When
        let publisher = repository.save(entities: entities)
        let result = try awaitPublisher(publisher)

        // Then
        XCTAssertTrue(try result.get() == ())
        XCTAssertNil(result.error)
    }

    func testSaveEntitiesWithFailure() throws {
        // Given
        let error = MarvelError.general
        let entities = EntityTestDouble.items(isThrowable: true)

        // When
        let publisher = repository.save(entities: entities)
        let result = try awaitPublisher(publisher)

        // Then
        XCTAssertNil(try? result.get())
        XCTAssertEqual(result.error as? MarvelError, error)
    }

    func testFetchAllWithSuccess() throws {
        // Given
        let entities = EntityTestDouble.items().sorted { $0.id.rawValue > $1.id.rawValue }

        // When
        repository.save(entities: entities)
        let publisher = repository.fetchAll()
        let result = try awaitPublisher(publisher)

        // Then
        XCTAssertEqual(try result.get(), entities)
        XCTAssertNil(result.error)
    }
}
