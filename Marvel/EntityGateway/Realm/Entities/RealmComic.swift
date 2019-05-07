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
    dynamic var id = 0
    dynamic var title: String?
    dynamic var thumbnail: RealmImage?
    
    convenience init(id: Int, title: String?, thumbnail: RealmImage?) {
        self.init()
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
    }
}

// MARK: - RealmRepresentable

extension Comic: RealmRepresentable {
    func asRealm() -> RealmComic {
        return RealmComic(
            id: id,
            title: title,
            thumbnail: thumbnail?.asRealm()
        )
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
