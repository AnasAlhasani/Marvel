//
//  DefaultMediaUseCase.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

final class DefaultMediaUseCase {
    private let gateway: MediaGateway
    private let repository: AnyRepository<Media>

    init(gateway: MediaGateway, repository: AnyRepository<Media>) {
        self.gateway = gateway
        self.repository = repository
    }
}

// MARK: - MediaUseCase

extension DefaultMediaUseCase: MediaUseCase {
    func loadMediaItems(with parameter: MediaParameter) -> Promise<MediaPaginator> {
        gateway
            .loadMediaItems(with: .init(parameter))
            .then { self.repository.save(entites: $0.results) }
            .recover { _ in self.repository.fetchAll().then { MediaPaginator(results: $0) } }
    }
}
