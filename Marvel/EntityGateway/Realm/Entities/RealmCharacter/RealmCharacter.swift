//
//  RealmCharacter.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmCharacter: Object {
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    @objc dynamic var charDescription: String?
    @objc dynamic var thumbnail: RealmImage?
    @objc dynamic var comics: RealmCharacterComic?
    
    convenience init(
        id: Int,
        name: String?,
        charDescription: String?,
        thumbnail: RealmImage?,
        comics: RealmCharacterComic?
    ) {
        self.init()
        self.id = id
        self.name = name
        self.charDescription = charDescription
        self.thumbnail = thumbnail
        self.comics = comics
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}

// MARK: - RealmRepresentable

extension ComicCharacter: RealmRepresentable {
    func asRealm() -> RealmCharacter {
        return RealmCharacter(
            id: id,
            name: name,
            charDescription: description,
            thumbnail: thumbnail?.asRealm(),
            comics: comics?.asRealm()
        )
    }
}

// MARK: - CoreConvertible

extension RealmCharacter: CoreConvertible {
    func asCore() -> ComicCharacter {
        return ComicCharacter(
            id: id,
            name: name,
            description: charDescription,
            thumbnail: thumbnail?.asCore(),
            comics: comics?.asCore()
        )
    }
}
