//
//  DefaultCharacterUseCase.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

final class DefaultCharacterUseCase<Repository: RepositoryProtocol> where Repository.Entity == ComicCharacter {
    private let gateway: CharacterGateway
    private let repository: Repository
    
    init(gateway: CharacterGateway, repository: Repository) {
        self.gateway = gateway
        self.repository = repository
    }
}

// MARK: - CharacterUseCase

extension DefaultCharacterUseCase: CharacterUseCase {
    func loadCharacters(with parameter: CharacterParameter) -> Promise<CharacterPaginator> {
        return gateway.loadCharacters(with: parameter)
    }
}
