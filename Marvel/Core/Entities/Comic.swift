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
    let issueNumber: Double?
    let description: String?
    let pageCount: Int?
    let thumbnail: Image?
}
