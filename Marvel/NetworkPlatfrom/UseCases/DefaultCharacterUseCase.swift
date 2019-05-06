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
    
    init(gateway: CharacterGateway = CharacterGateway()) {
        self.gateway = gateway
    }
}

// MARK: - CharacterUseCase

extension DefaultCharacterUseCase: CharacterUseCase {
    func loadCharacters(with parameter: CharacterParameter) -> Promise<CharacterPaginator> {
        return gateway.loadCharacters(with: parameter)
    }
}
