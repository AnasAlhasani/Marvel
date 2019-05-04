//
//  ComicCharacter.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

struct ComicCharacter: Decodable {
    let id: Int
    let name: String?
    let description: String?
    let thumbnail: Image?
    let comics: Comic?
}

extension ComicCharacter {
    struct Comic: Decodable {
        let items: [Item]?
    }
    struct Item: Decodable {
        let name: String?
        let resourceURI: ResourceURI?
    }
}
