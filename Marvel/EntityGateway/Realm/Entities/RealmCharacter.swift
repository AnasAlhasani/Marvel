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
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}

// MARK: - RealmRepresentable

extension MarvelCharacter: RealmRepresentable {
    func asRealm() -> RealmCharacter {
        return RealmCharacter.build {
            $0.id = id
            $0.name = name
            $0.charDescription = description
            $0.thumbnail = thumbnail?.asRealm()
        }
    }
}

// MARK: - CoreConvertible

extension RealmCharacter: CoreConvertible {
    func asCore() -> MarvelCharacter {
        return MarvelCharacter(
            id: id,
            name: name,
            description: charDescription,
            thumbnail: thumbnail?.asCore()
        )
    }
}
