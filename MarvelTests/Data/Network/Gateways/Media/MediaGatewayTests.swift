//
//  MediaGatewayTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 13/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation
@testable import Marvel
import XCTest

final class MediaGatewayTests: XCTestCase {
    var apiClientSpy: APIClientSpy<Media>!
    var mediaGateway: MediaGateway!

    override func setUp() {
        apiClientSpy = .init()
        mediaGateway = APIMarvelMediaGateway(apiClient: apiClientSpy)
    }

    override func tearDown() {
        apiClientSpy = nil
        mediaGateway = nil
        super.tearDown()
    }

    func testLoadMediaWithSuccess() throws {
        // Given
        let results = Media.items()
        let paginator = Paginator.value(results: results)
        let parameter = MarvelParameter(MediaParameter(id: 1, type: .comics))
        apiClientSpy.promise = .init { MarvelResponse(data: paginator) }

        // When
        let publisher = mediaGateway.loadMediaItems(with: parameter)
        let result = try awaitPublisher(publisher)

        // Then
        XCTAssertEqual(apiClientSpy.request.path, "characters/\(parameter.value.id)/\(parameter.value.type.rawValue)")
        XCTAssertEqual(apiClientSpy.request.method, .get)
        XCTAssertEqual(
            apiClientSpy.request.urlParameters,
            try? MarvelParameter(parameter).encoded()
        )
        XCTAssertEqual(try result.get(), paginator)
        XCTAssertNil(result.error)
    }

    func testLoadMediaWithFailure() throws {
        // Given
        let error = MarvelError.general
        let parameter = MarvelParameter(MediaParameter(id: 1, type: .comics))
        apiClientSpy.promise = .init { MarvelResponse<Media>(message: error.message) }

        // When
        let publisher = mediaGateway.loadMediaItems(with: parameter)
        let result = try awaitPublisher(publisher)

        // Then
        XCTAssertNil(try? result.get())
        XCTAssertEqual(result.error as? MarvelError, error)
    }
}
