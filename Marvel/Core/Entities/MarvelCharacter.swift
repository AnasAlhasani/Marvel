//
//  MarvelCharacter.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

struct MarvelCharacter: Decodable {
    let id: Int
    let name: String?
    let description: String?
    let thumbnail: Image?
}
