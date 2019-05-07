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
    
    private(set) var offset: Int
    private(set) var limit: Int
    private(set) var total: Int
    private(set) var count: Int
    private(set) var results: Value
    
    init(
        offset: Int = 0,
        limit: Int = 0,
        total: Int = 0,
        count: Int = 0,
        results: Value
    ) {
        self.offset = offset
        self.limit = limit
        self.total = total
        self.count = count
        self.results = results
    }
    
    var hasMorePages: Bool {
        return total - (offset + limit) > 0
    }
    
    var nextOffset: Int {
        return hasMorePages ? offset + limit : offset
    }
}
