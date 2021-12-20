//
//  CharacterUseCase.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation

// MARK: - Types

typealias CharacterPaginator = Paginator<MarvelCharacter>
typealias CharacterResult = Result<CharacterPaginator, Error>
typealias CharacterPublisher = AnyPublisher<CharacterResult, Never>

// MARK: - Parameters

struct CharacterParameter: Parameter {
    private let offset: Int
    private let limit: Int
    private let nameStartsWith: String?

    init(
        offset: Int = .zero,
        limit: Int = Config.pageLimit,
        query: String? = nil
    ) {
        self.offset = offset
        self.limit = limit
        self.nameStartsWith = query?.nilIfEmpty?.lowercased()
    }
}

// MARK: - UseCase

protocol CharacterUseCase {
    func loadCharacters(with parameter: CharacterParameter) -> CharacterPublisher
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
    func loadCharacters(with parameter: CharacterParameter) -> CharacterPublisher {
        gateway
            .loadCharacters(with: .init(parameter))
            .map { [repository] paginator -> AnyPublisher<CharacterPaginator, Error> in
                repository.save(entites: paginator.results)
                return .just(paginator)
            }
            .switchToLatest()
            .catch { [repository] _ in repository.fetchAll().map { CharacterPaginator(results: $0) } }
            .convertToResult()
            .eraseToAnyPublisher()
    }
}
