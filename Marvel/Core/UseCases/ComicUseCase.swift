//
//  ComicUseCase.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

// MARK: - Typealias

typealias ComicPaginator = Paginator<[Comic]>

// MARK: - UseCase

protocol ComicUseCase {
    func loadComics(with parameter: ComicParameter) -> Promise<ComicPaginator>
}

// MARK: - Parameters

struct ComicParameter: Encodable {
    private(set) var id: Int
}
