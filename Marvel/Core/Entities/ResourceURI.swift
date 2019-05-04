//
//  ResourceURI.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

struct ResourceURI: Decodable {
    let comicId: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let uri = try container.decode(String.self)
        guard let url = URL(string: uri), let comicId = Int(url.lastPathComponent) else {
            throw MarvelError.decode
        }
        self.comicId = comicId
    }
}
