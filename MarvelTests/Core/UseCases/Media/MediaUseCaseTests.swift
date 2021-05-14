//
//  MediaUseCaseTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import XCTest

@testable import Marvel
@testable import Promises

final class MediaUseCaseTests: XCTestCase {
    var repositroyStub: RepositoryStub<Media>!
    var gatewayStub: MediaGatewayStub!
    var useCase: MediaUseCase!

    override func setUp() {
        super.setUp()
        repositroyStub = .init()
        gatewayStub = .init()
        useCase = DefaultMediaUseCase(
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

    func testLoadMedia() {
        // Given
        let results = Media.items()
        let paginator = Paginator.paginator(results: results)
        let parameter = MediaParameter(id: 1, type: .comics)
        gatewayStub.promise = .init { paginator }
        repositroyStub.savePromise = .init {}

        // When
        let promise = useCase.loadMediaItems(with: parameter)

        // Then
        XCTAssert(waitForPromises(timeout: 1.0))

        // XCTAssertEqual(gatewayStub.parameter, .init(parameter))
        XCTAssertEqual(gatewayStub.callCount, 1)
        XCTAssertEqual(gatewayStub.promise.value, paginator)
        XCTAssertNil(gatewayStub.promise.error)

        XCTAssertEqual(repositroyStub.entites, results)
        XCTAssertEqual(repositroyStub.saveCallCount, 1)
        XCTAssertTrue(repositroyStub.savePromise.value! == ())
        XCTAssertNil(repositroyStub.savePromise.error)

        XCTAssertEqual(promise.value, paginator)
        XCTAssertNil(promise.error)
    }

    func testLoadMediaWithRecoverWhenAPIFails() {
        // Given
        let error = MarvelError.general
        let results = Media.items()
        let paginator = Paginator.paginator(results: results)
        let parameter = MediaParameter(id: 1, type: .comics)
        gatewayStub.promise = .init(error)
        repositroyStub.savePromise = .init {}
        repositroyStub.fetchPromise = .init { results }

        // When
        let promise = useCase.loadMediaItems(with: parameter)

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
