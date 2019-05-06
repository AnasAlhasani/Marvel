//
//  Optional.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/6/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var defaultIfEmpty: String {
        switch self {
        case let .some(value):
            return value.nilIfEmpty ?? "Not Available."
        case .none:
            return "Not Available."
        }
    }
}
