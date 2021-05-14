//
//  MediaUseCase.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

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
    func loadMediaItems(with parameter: MediaParameter) -> Promise<MediaPaginator>
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
    func loadMediaItems(with parameter: MediaParameter) -> Promise<MediaPaginator> {
        gateway
            .loadMediaItems(with: .init(parameter))
            .then { self.repository.save(entites: $0.results) }
            .recover { _ in self.repository.fetchAll().then { MediaPaginator(results: $0) } }
    }
}
