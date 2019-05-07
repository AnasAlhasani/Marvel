//
//  RealmCharacterComic.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmCharacterComic: Object {
    dynamic var items: [RealmCharacterComicItem]?
    
    convenience init(items: [RealmCharacterComicItem]?) {
        self.init()
        self.items = items
    }
}

// MARK: - RealmRepresentable

extension ComicCharacter.Comic: RealmRepresentable {
    func asRealm() -> RealmCharacterComic {
        return RealmCharacterComic(
            items: items?.asRealm()
        )
    }
}

// MARK: - CoreConvertible

extension RealmCharacterComic: CoreConvertible {
    func asCore() -> ComicCharacter.Comic {
        return ComicCharacter.Comic(
            items: items?.asCore()
        )
    }
}
