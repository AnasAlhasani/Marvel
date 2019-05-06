//
//  DefaultComicUseCase.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

final class DefaultComicUseCase {
    private let gateway: ComicGateway
    
    init(gateway: ComicGateway = ComicGateway()) {
        self.gateway = gateway
    }
}

// MARK: - ComicUseCase

extension DefaultComicUseCase: ComicUseCase {
    func loadComics(with parameter: ComicParameter) -> Promise<ComicPaginator> {
        return gateway.loadComics(with: parameter)
    }
}
