//
//  APIComicUseCase.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

final class APIComicUseCase {
    private let gateway: APIGateway
    
    init(gateway: APIGateway = DefaultAPIGateway()) {
        self.gateway = gateway
    }
}

// MARK: - ComicUseCase

extension APIComicUseCase: ComicUseCase {
    func loadComics(with parameter: ComicParameter) -> Promise<ComicPaginator> {
        let request = RequestBuilder<[Comic]>()
            .path("comics/\(parameter.id)")
            .method(.get)
            .urlParameters(MarvelParameter<VoidParameter>())
            .build()
        return gateway.execute(request)
    }
}
