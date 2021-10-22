//
//  APICharacterGateway.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import CoreNetwork

final class APICharacterGateway: CharacterGateway {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}

extension APICharacterGateway {
    func loadCharacters(with parameter: MarvelParameter<CharacterParameter>) -> AnyPublisher<CharacterPaginator, Error> {
        let request = RequestBuilder<MarvelCharacter>()
            .path("characters")
            .method(.get)
            .urlParameters(parameter)
            .build()
        return apiClient.execute(request)
    }
}
