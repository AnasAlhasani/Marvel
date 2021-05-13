//
//  APIClient.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import CoreNetwork
import Promises

// MARK: - Typealias

typealias RequestBuilder<T: Entity> = CoreNetwork.RequestBuilder<MarvelResponse<T>>
typealias Promise<T> = Promises.Promise<T>

// MARK: - APIClient

// Checkout my CoreNetwork framework: https://github.com/AnasAlhasani/CoreNetwork
extension APIClient {
    func execute<T: APIRequest, D: Decodable>(_ request: T) -> Promise<Paginator<D>> {
        Promise<Paginator<D>>(on: .global(qos: .background)) { fullfill, reject in
            self.execute(request).then {
                let response = $0 as? MarvelResponse<D>

                if let dataContainer = response?.data {
                    fullfill(dataContainer)
                } else if let message = response?.message {
                    reject(MarvelError(message))
                } else {
                    reject(MarvelError.general)
                }
            }.catch {
                reject($0)
            }
        }
    }
}
