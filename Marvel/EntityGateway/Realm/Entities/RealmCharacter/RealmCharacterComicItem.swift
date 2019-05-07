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
    
    convenience init(name: String?, resourceURI: RealmResourceURI?) {
        self.init()
        self.name = name
        self.resourceURI = resourceURI
    }
}

// MARK: - RealmRepresentable

extension ComicCharacter.Item: RealmRepresentable {
    func asRealm() -> RealmCharacterComicItem {
        return RealmCharacterComicItem(
            name: name,
            resourceURI: resourceURI?.asRealm()
        )
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
