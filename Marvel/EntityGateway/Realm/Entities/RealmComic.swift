//
//  RealmComic.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmComic: Object {
    @objc dynamic var id = 0
    @objc dynamic var title: String?
    @objc dynamic var thumbnail: RealmImage?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - RealmRepresentable

extension Comic: RealmRepresentable {
    func asRealm() -> RealmComic {
        return RealmComic.build {
            $0.id = id
            $0.title = title
            $0.thumbnail = thumbnail?.asRealm()
        }
    }
}

// MARK: - CoreConvertible

extension RealmComic: CoreConvertible {
    func asCore() -> Comic {
        return Comic(
            id: id,
            title: title,
            thumbnail: thumbnail?.asCore()
        )
    }
}
