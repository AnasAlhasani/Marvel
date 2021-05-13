//
//  DefaultCharacterUseCase.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

final class DefaultCharacterUseCase {
    private let gateway: CharacterGateway
    private let repository: AnyRepository<MarvelCharacter>

    init(gateway: CharacterGateway, repository: AnyRepository<MarvelCharacter>) {
        self.gateway = gateway
        self.repository = repository
    }
}

// MARK: - CharacterUseCase

extension DefaultCharacterUseCase: CharacterUseCase {
    func loadCharacters(with parameter: CharacterParameter) -> Promise<CharacterPaginator> {
        gateway
            .loadCharacters(with: .init(parameter))
            .then { self.repository.save(entites: $0.results) }
            .recover { _ in self.repository.fetchAll().then { CharacterPaginator(results: $0) } }
    }
}
