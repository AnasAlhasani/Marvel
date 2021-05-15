//
//  Paginator.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 13/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation
@testable import Marvel

extension Paginator {
    static func value(
        offset: Int = 0,
        limit: Int = 20,
        total: Int = 40,
        count: Int = 20,
        results: [Value]
    ) -> Self {
        .init(
            offset: offset,
            limit: limit,
            total: total,
            count: count,
            results: results
        )
    }

    func next(with results: [Value]) -> Self {
        .init(
            offset: nextOffset,
            limit: limit,
            total: total,
            count: count,
            results: results
        )
    }
}
