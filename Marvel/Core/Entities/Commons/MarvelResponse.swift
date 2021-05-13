//
//  MarvelResponse.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

struct MarvelResponse<Value: Entity>: Entity {
    let status: String?
    let message: String?
    let data: Paginator<Value>?

    init(
        status: String? = nil,
        message: String? = nil,
        data: Paginator<Value>? = nil
    ) {
        self.status = status
        self.message = message
        self.data = data
    }
}
