//
//  APICharacterUseCase.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

final class APICharacterUseCase {
    private let gateway: APIGateway
    
    init(gateway: APIGateway = DefaultAPIGateway()) {
        self.gateway = gateway
    }
}

// MARK: - ComicCharacterUseCase

extension APICharacterUseCase: CharacterUseCase {
    func loadCharacters(with parameter: CharacterParameter) -> Promise<CharacterPaginator> {
        let request = RequestBuilder<[ComicCharacter]>()
            .path("characters")
            .method(.get)
            .urlParameters(MarvelParameter(parameter))
            .build()
        return gateway.execute(request)
    }
}
