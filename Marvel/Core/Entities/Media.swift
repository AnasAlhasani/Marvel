//
//  Media.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

struct Media: IdentifiableEntity {
    let id: ID
    let title: String?
    let thumbnail: Image?

    init(
        id: ID,
        title: String?,
        thumbnail: Image?
    ) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
    }
}
