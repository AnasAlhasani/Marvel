//
//  State.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

enum State<Value> {
    case `default`
    case loading
    case paging([Value], next: Int)
    case populated([Value])
    case empty
    case error(Error)

    var items: [Value] {
        switch self {
        case let .paging(items, _):
            return items
        case let .populated(items):
            return items
        default:
            return []
        }
    }
}
