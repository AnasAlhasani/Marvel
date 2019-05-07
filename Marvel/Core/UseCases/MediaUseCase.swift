//
//  MediaUseCase.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

// MARK: - Typealias

typealias MediaPaginator = Paginator<[Media]>

// MARK: - UseCase

protocol MediaUseCase {
    func loadMediaItems(with parameter: MediaParameter) -> Promise<MediaPaginator>
}

// MARK: - Parameters

struct MediaParameter: Encodable {
    private(set) var id: Int
    private(set) var type: MediaType
    
    enum CodingKeys: String, CodingKey {
        case id
    }
}
