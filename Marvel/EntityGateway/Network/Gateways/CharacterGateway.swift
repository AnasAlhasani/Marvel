//
//  CharacterGateway.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import CoreNetwork

final class CharacterGateway {
    private let apiClient: APIClient

    init(apiClient: APIClient = DefaultAPIClient()) {
        self.apiClient = apiClient
    }
}

extension CharacterGateway {
    func loadCharacters(with parameter: CharacterParameter) -> Promise<CharacterPaginator> {
        let request = RequestBuilder<[MarvelCharacter]>()
            .path("characters")
            .method(.get)
            .urlParameters(MarvelParameter(parameter))
            .build()
        return apiClient.execute(request)
    }
}
