//
//  EntityTestDouble.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 13/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation
@testable import Marvel

struct EntityTestDouble: IdentifiableEntity {
    private(set) var id: ID
    private static var isThrowable = false

    init(id: ID) {
        self.id = id
    }

    init(from decoder: Decoder) throws {
        if Self.isThrowable {
            Self.isThrowable = false
            throw MarvelError.general
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(ID.self, forKey: .id)
        }
    }

    func encode(to encoder: Encoder) throws {
        if Self.isThrowable {
            Self.isThrowable = false
            throw MarvelError.general
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
    }
}

extension EntityTestDouble {
    static func items(
        numberOfElements: Int = 2,
        isThrowable: Bool = false
    ) -> [Self] {
        var items = [Self]()
        Self.isThrowable = isThrowable
        for index in 0..<numberOfElements {
            let item = item(index: index)
            items.append(item)
        }
        return items
    }

    static func item(index: Int) -> Self {
        .init(id: .init(rawValue: index))
    }
}
