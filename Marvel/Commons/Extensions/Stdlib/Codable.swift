//
//  Codable.swift
//  Marvel
//
//  Created by Anas Alhasani on 9/30/20.
//  Copyright © 2020 Anas Alhasani. All rights reserved.
//

import Foundation

extension Data {
    func decoded<T: Decodable>() throws -> T {
        try JSONDecoder().decode(T.self, from: self)
    }
}

extension Encodable {
    func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
}
