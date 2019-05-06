//
//  Comic.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

struct Comic: Decodable {
    let id: Int
    let title: String?
    let thumbnail: Image?
}
