//
//  AnyRepositoryTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

@testable import Marvel
@testable import Promises
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

    func testSaveEntitiesWithSuccess() {
        // Given
        let entites = EntityTestDouble.items()
        spy.savePromise = .init {}

        // When
        let promise = repository.save(entites: entites)

        // Then
        XCTAssert(waitForPromises(timeout: 10.0))
        XCTAssertTrue(promise.value! == ())
        XCTAssertNil(promise.error)
        XCTAssertEqual(spy.entites, entites)
        XCTAssertEqual(spy.saveCallCount, 1)
    }

    func testSaveEntitiesWithFailure() {
        // Given
        let entites = EntityTestDouble.items()
        let error = MarvelError.general
        spy.savePromise = .init(error)

        // When
        let promise = repository.save(entites: entites)

        // Then
        XCTAssert(waitForPromises(timeout: 10.0))
        XCTAssertNil(promise.value)
        XCTAssertEqual(promise.error as? MarvelError, error)
        XCTAssertEqual(spy.entites, entites)
        XCTAssertEqual(spy.saveCallCount, 1)
    }

    func testFetchAllWithSuccess() {
        // Given
        let entites = EntityTestDouble.items()
        spy.fetchPromise = .init { entites }

        // When
        let promise = repository.fetchAll()

        // Then
        XCTAssert(waitForPromises(timeout: 10.0))
        XCTAssertEqual(promise.value, entites)
        XCTAssertNil(promise.error)
        XCTAssertEqual(spy.fetchCallCount, 1)
    }

    func testFetchAllWithFailure() {
        // Given
        let error = MarvelError.general
        spy.fetchPromise = .init(error)

        // When
        let promise = repository.fetchAll()

        // Then
        XCTAssert(waitForPromises(timeout: 10.0))
        XCTAssertNil(promise.value)
        XCTAssertEqual(promise.error as? MarvelError, error)
        XCTAssertEqual(spy.fetchCallCount, 1)
    }
}
