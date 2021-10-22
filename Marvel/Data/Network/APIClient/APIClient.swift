//
//  APIClient.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import CoreNetwork

// MARK: - Typealias

typealias RequestBuilder<T: Entity> = CoreNetwork.RequestBuilder<MarvelResponse<T>>

// MARK: - APIClient

extension APIClient {
    /// CoreNetwork: https://github.com/AnasAlhasani/CoreNetwork
    func execute<T: APIRequest, D: Decodable>(_ request: T) -> AnyPublisher<Paginator<D>, Error> {
        Future { promise in
            execute(request).then {
                let response = $0 as? MarvelResponse<D>

                if let dataContainer = response?.data {
                    promise(.success(dataContainer))
                } else if let message = response?.message {
                    promise(.failure(MarvelError(message)))
                } else {
                    promise(.failure(MarvelError.general))
                }
            }.catch {
                promise(.failure($0))
            }
        }.eraseToAnyPublisher()
    }
}
