//
//  APIMarvelMediaGateway.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import CoreNetwork

final class APIMarvelMediaGateway: MediaGateway {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}

extension APIMarvelMediaGateway {
    func loadMediaItems(with parameter: MarvelParameter<MediaParameter>) -> AnyPublisher<MediaPaginator, Error> {
        let request = RequestBuilder<Media>()
            .path("characters/\(parameter.value.id)/\(parameter.value.type.rawValue)")
            .method(.get)
            .urlParameters(parameter)
            .build()
        return apiClient.execute(request)
    }
}
