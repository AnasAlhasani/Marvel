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
    static func paginator(
        results: [Value],
        offset: Int = 0,
        limit: Int = 0,
        total: Int = 0,
        count: Int = 0
    ) -> Self {
        .init(
            offset: offset,
            limit: limit,
            total: total,
            count: count,
            results: results
        )
    }
}
