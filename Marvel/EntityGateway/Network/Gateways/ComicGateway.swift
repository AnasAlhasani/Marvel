//
//  ComicGateway.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import CoreNetwork

final class ComicGateway {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = DefaultAPIClient()) {
        self.apiClient = apiClient
    }
}

extension ComicGateway {
    func loadComics(with parameter: ComicParameter) -> Promise<ComicPaginator> {
        let request = RequestBuilder<[Comic]>()
            .path("comics/\(parameter.id)")
            .method(.get)
            .urlParameters(MarvelParameter<VoidParameter>())
            .build()
        return apiClient.execute(request)
    }
}
