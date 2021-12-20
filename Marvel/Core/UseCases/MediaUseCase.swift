//
//  MediaUseCase.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation

// MARK: - Paginator

typealias MediaPaginator = Paginator<Media>

// MARK: - Parameters

struct MediaParameter: Parameter {
    private(set) var id: MarvelCharacter.ID
    private(set) var type: MediaType

    func encode(to encoder: Encoder) throws {}
}

// MARK: - UseCase

protocol MediaUseCase {
    func loadMediaItems(with parameter: MediaParameter) -> AnyPublisher<MediaPaginator, Error>
}

final class DefaultMediaUseCase {
    private let gateway: MediaGateway
    private let repository: AnyRepository<Media>

    init(gateway: MediaGateway, repository: AnyRepository<Media>) {
        self.gateway = gateway
        self.repository = repository
    }
}

extension DefaultMediaUseCase: MediaUseCase {
    func loadMediaItems(with parameter: MediaParameter) -> AnyPublisher<MediaPaginator, Error> {
        gateway
            .loadMediaItems(with: .init(parameter))
            .map { [repository] paginator -> AnyPublisher<MediaPaginator, Error> in
                repository.save(entities: paginator.results)
                return .just(paginator)
            }
            .switchToLatest()
            .catch { [repository] _ in repository.fetchAll().map { MediaPaginator(results: $0) } }
            .eraseToAnyPublisher()
    }
}
