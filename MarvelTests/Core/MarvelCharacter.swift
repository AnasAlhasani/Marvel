//
//  MarvelCharacter.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 13/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation
@testable import Marvel

extension MarvelCharacter {
    static func items(numberOfElements: Int = 2) -> [Self] {
        var items = [Self]()
        for index in 0..<numberOfElements {
            let item = item(index: index)
            items.append(item)
        }
        return items
    }

    static func item(index: Int) -> Self {
        .init(
            id: .init(rawValue: index),
            name: "name:\(index)",
            description: "description:\(index)",
            thumbnail: .init(
                path: "path\(index)",
                extension: "extension\(index)"
            )
        )
    }
}
