//
//  APIClientSpy.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 13/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import CoreNetwork
import Foundation
@testable import Marvel
import Promises

final class APIClientSpy<Response: Entity>: APIClient {
    var configuration: ServiceConfigurator
    var request: DefaultRequest<Response>!
    var promise: Promise<MarvelResponse<Response>>!

    init(_ configuration: ServiceConfigurator = .mock) {
        self.configuration = configuration
    }

    func execute<T: APIRequest>(_ request: T) -> Promise<T.Response> {
        self.request = .init(
            path: request.path,
            method: request.method,
            headers: request.headers,
            urlParameters: request.urlParameters,
            httpBody: request.httpBody,
            bodyEncoding: request.bodyEncoding
        )

        return promise as! Promise<T.Response>
    }
}

private extension ServiceConfigurator {
    static let mock = ServiceConfigurator(baseURL: "www.marvel.com")
}
