//
//  RealmRepositoryTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

@testable import Marvel
@testable import Promises
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

    func testSaveEntitiesWithSuccess() {
        // Given
        let entites = EntityTestDouble.items()

        // When
        let promise = repository.save(entites: entites)

        // Then
        XCTAssert(waitForPromises(timeout: 1.0))
        XCTAssertTrue(promise.value == ())
        XCTAssertNil(promise.error)
    }

    func testSaveEntitiesWithFailure() {
        // Given
        let error = MarvelError.general
        let entites = EntityTestDouble.items(isThrowable: true)

        // When
        let promise = repository.save(entites: entites)

        // Then
        XCTAssert(waitForPromises(timeout: 1.0))
        XCTAssertNil(promise.value)
        XCTAssertEqual(promise.error as? MarvelError, error)
    }

    func testFetchAllWithSuccess() {
        // Given
        let entites = EntityTestDouble.items().sorted { $0.id.rawValue > $1.id.rawValue }

        // When
        repository.save(entites: entites)
        let promise = repository.fetchAll()

        // Then
        XCTAssert(waitForPromises(timeout: 1.0))
        XCTAssertEqual(promise.value, entites)
        XCTAssertNil(promise.error)
    }
}
