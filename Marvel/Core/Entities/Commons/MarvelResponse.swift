//
//  MarvelResponse.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

struct MarvelResponse<Value: Decodable>: Decodable {
    let status: String?
    let message: String?
    let data: Paginator<Value>?
}

struct Paginator<Value: Decodable>: Decodable {
    
    private let offset: Int
    private let limit: Int
    private let total: Int
    private let count: Int
    let results: Value

    var hasMorePages: Bool {
        return total - (offset + limit) > 0
    }
    
    var nextOffset: Int {
        return hasMorePages ? offset + limit : offset
    }
}
