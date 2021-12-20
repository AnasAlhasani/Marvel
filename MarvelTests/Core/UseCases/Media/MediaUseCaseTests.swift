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
    var repositoryStub: RepositoryStub<Media>!
    var gatewayStub: MediaGatewayStub!
    var useCase: MediaUseCase!

    override func setUp() {
        super.setUp()
        repositoryStub = .init()
        gatewayStub = .init()
        useCase = DefaultMediaUseCase(
            gateway: gatewayStub,
            repository: repositoryStub.eraseToAnyRepository()
        )
    }

    override func tearDown() {
        repositoryStub = nil
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
        repositoryStub.savePublisher = .just(())

        // When
        let publisher = useCase.loadMediaItems(with: parameter)

        // Then
        let result = try awaitPublisher(publisher).get()
        // XCTAssertEqual(gatewayStub.parameter, .init(parameter))
        XCTAssertEqual(gatewayStub.callCount, 1)
        XCTAssertEqual(gatewayStub.publisher.value, paginator)
        XCTAssertNil(gatewayStub.publisher.error)

        XCTAssertEqual(repositoryStub.entites, results)
        XCTAssertEqual(repositoryStub.saveCallCount, 1)
        XCTAssertTrue(repositoryStub.savePublisher.value! == ())
        XCTAssertNil(repositoryStub.savePublisher.error)

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
        repositoryStub.savePublisher = .just(())
        repositoryStub.fetchPublisher = .just(results)

        // When
        let publisher = useCase.loadMediaItems(with: parameter)
        let result = try awaitPublisher(publisher).get()

        // Then
        XCTAssertEqual(gatewayStub.callCount, 1)
        XCTAssertNil(gatewayStub.publisher.value)
        XCTAssertEqual(gatewayStub.publisher.error as? MarvelError, error)

        XCTAssertEqual(repositoryStub.fetchCallCount, 1)
        XCTAssertEqual(repositoryStub.fetchPublisher.value, results)
        XCTAssertNil(repositoryStub.fetchPublisher.error)

        XCTAssertEqual(try result.get(), paginator)
        XCTAssertNil(result.error)
    }
}
