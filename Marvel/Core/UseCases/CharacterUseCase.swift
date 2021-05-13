//
//  CharacterUseCase.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

// MARK: - Typealias

typealias CharacterPaginator = Paginator<MarvelCharacter>

// MARK: - UseCase

protocol CharacterUseCase {
    func loadCharacters(with parameter: CharacterParameter) -> Promise<CharacterPaginator>
}

// MARK: - Parameters

struct CharacterParameter: Parameter {
    private let nameStartsWith: String?
    private let limit: Int?
    private let offset: Int?

    init(
        query: String? = nil,
        limit: Int? = nil,
        offset: Int? = nil
    ) {
        self.nameStartsWith = query
        self.limit = limit
        self.offset = offset
    }
}
