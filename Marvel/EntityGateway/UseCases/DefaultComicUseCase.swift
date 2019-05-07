//
//  DefaultComicUseCase.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

final class DefaultComicUseCase<Repository: RepositoryProtocol> where Repository.Entity == Comic {
    private let gateway: ComicGateway
    private let repository: Repository
    
    init(gateway: ComicGateway, repository: Repository) {
        self.gateway = gateway
        self.repository = repository
    }
}

// MARK: - ComicUseCase

extension DefaultComicUseCase: ComicUseCase {
    func loadComics(with parameter: ComicParameter) -> Promise<ComicPaginator> {
        return gateway.loadComics(with: parameter)
    }
}
