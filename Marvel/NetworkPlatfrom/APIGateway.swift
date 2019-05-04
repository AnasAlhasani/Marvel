//
//  APIGateway.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import CoreNetwork
import Promises

// MARK: - Typealias

typealias RequestBuilder<T: Decodable> = CoreNetwork.RequestBuilder<MarvelResponse<T>>
typealias Promise<T> = Promises.Promise<T>

// MARK: - APIGateway

protocol APIGateway {
    func execute<T: APIRequest, D: Decodable>(_ request: T) -> Promise<Paginator<D>>
}

// MARK: - DefaultAPIGateway

final class DefaultAPIGateway {

    private let apiClient: APIClient
    
    // Checkout my CoreNetwork framework: https://github.com/AnasAlhasani/CoreNetwork
    init(apiClient: APIClient = DefaultAPIClient()) {
        self.apiClient = apiClient
    }
}

extension DefaultAPIGateway: APIGateway {
    
    func execute<T: APIRequest, D: Decodable>(_ request: T) -> Promise<Paginator<D>> {
        return Promise<Paginator<D>>(on: .global(qos: .background)) { fullfill, reject in
            self.apiClient.execute(request).then {
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
