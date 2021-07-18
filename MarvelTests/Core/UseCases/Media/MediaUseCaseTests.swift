//
//  MediaUseCaseTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

@testable import Marvel
import XCTest

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

    func testLoadMedia() throws {
        // Given
        let results = Media.items()
        let paginator = Paginator.value(results: results)
        let parameter = MediaParameter(id: 1, type: .comics)
        gatewayStub.publisher = .just(paginator)
        repositroyStub.savePublisher = .just(())

        // When
        let publisher = useCase.loadMediaItems(with: parameter)

        // Then
        let result = try awaits(for: publisher)
        // XCTAssertEqual(gatewayStub.parameter, .init(parameter))
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

    func testLoadMediaWithRecoverWhenAPIFails() throws {
        // Given
        let error = MarvelError.general
        let results = Media.items()
        let paginator = Paginator.value(offset: 0, limit: 0, total: 0, count: 0, results: results)
        let parameter = MediaParameter(id: 1, type: .comics)
        gatewayStub.publisher = .fail(with: error)
        repositroyStub.savePublisher = .just(())
        repositroyStub.fetchPublisher = .just(results)

        // When
        let publisher = useCase.loadMediaItems(with: parameter)
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
