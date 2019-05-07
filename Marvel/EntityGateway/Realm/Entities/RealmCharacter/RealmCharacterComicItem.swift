//
//  RealmCharacterComicItem.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmCharacterComicItem: Object {
    dynamic var name: String?
    dynamic var resourceURI: RealmResourceURI?
}

// MARK: - RealmRepresentable

extension ComicCharacter.Item: RealmRepresentable {
    func asRealm() -> RealmCharacterComicItem {
        return RealmCharacterComicItem.build {
            $0.name = name
            $0.resourceURI = resourceURI?.asRealm()
        }
    }
}

// MARK: - CoreConvertible

extension RealmCharacterComicItem: CoreConvertible {
    func asCore() -> ComicCharacter.Item {
        return ComicCharacter.Item(
            name: name,
            resourceURI: resourceURI?.asCore()
        )
    }
}
