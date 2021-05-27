//
//  CharacterUseCase.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation

// MARK: - Paginator

typealias CharacterPaginator = Paginator<MarvelCharacter>

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

// MARK: - UseCase

protocol CharacterUseCase {
    func loadCharacters(with parameter: CharacterParameter) -> AnyPublisher<CharacterPaginator, Error>
}

final class DefaultCharacterUseCase {
    private let gateway: CharacterGateway
    private let repository: AnyRepository<MarvelCharacter>

    init(gateway: CharacterGateway, repository: AnyRepository<MarvelCharacter>) {
        self.gateway = gateway
        self.repository = repository
    }
}

extension DefaultCharacterUseCase: CharacterUseCase {
    func loadCharacters(with parameter: CharacterParameter) -> AnyPublisher<CharacterPaginator, Error> {
        gateway
            .loadCharacters(with: .init(parameter))
            .map { [repository] paginator -> AnyPublisher<CharacterPaginator, Error> in
                repository.save(entites: paginator.results)
                return .just(paginator)
            }
            .switchToLatest()
            .catch { [repository] _ in repository.fetchAll().map { CharacterPaginator(results: $0) } }
            .eraseToAnyPublisher()
    }
}
