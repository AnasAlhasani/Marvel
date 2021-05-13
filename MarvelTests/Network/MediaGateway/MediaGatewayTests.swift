//
//  MediaGatewayTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 13/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation
@testable import Marvel
@testable import Promises
import XCTest

final class MediaGatewayTests: XCTestCase {
    var apiClientSpy: APIClientSpy<Media>!
    var mediaGateway: MarvelMediaGateway!

    override func setUp() {
        apiClientSpy = .init()
        mediaGateway = .init(apiClient: apiClientSpy)
    }

    override func tearDown() {
        apiClientSpy = nil
        mediaGateway = nil
        super.tearDown()
    }

    func testLoadMediaWithSuccess() {
        // Given
        let results = Media.items()
        let paginator = Paginator.paginator(results: results)
        let parameter = MarvelParameter(MediaParameter(id: 1, type: .comics))
        apiClientSpy.promise = .init { MarvelResponse(data: paginator) }

        // When
        let promise = mediaGateway.loadMediaItems(with: parameter)

        // Then

        XCTAssert(waitForPromises(timeout: 1.0))
        XCTAssertEqual(apiClientSpy.request.path, "characters/\(parameter.value.id)/\(parameter.value.type.rawValue)")
        XCTAssertEqual(apiClientSpy.request.method, .get)
        XCTAssertEqual(
            apiClientSpy.request.urlParameters,
            try? MarvelParameter(parameter).encoded()
        )
        XCTAssertEqual(promise.value, paginator)
        XCTAssertNil(promise.error)
    }

    func testLoadMediaWithFailure() {
        // Given
        let error = MarvelError.general
        let parameter = MarvelParameter(MediaParameter(id: 1, type: .comics))
        apiClientSpy.promise = .init { MarvelResponse<Media>(message: error.message) }

        // When
        let promise = mediaGateway.loadMediaItems(with: parameter)

        // Then

        XCTAssert(waitForPromises(timeout: 1.0))

        XCTAssertNil(promise.value)
        XCTAssertEqual(promise.error as? MarvelError, error)
    }
}
