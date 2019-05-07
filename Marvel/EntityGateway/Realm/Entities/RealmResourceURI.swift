//
//  RealmResourceURI.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmResourceURI: Object {
    dynamic var comicId = 0
}

// MARK: - RealmRepresentable

extension ResourceURI: RealmRepresentable {
    func asRealm() -> RealmResourceURI {
        return RealmResourceURI.build { $0.comicId = comicId }
    }
}

// MARK: - CoreConvertible

extension RealmResourceURI: CoreConvertible {
    func asCore() -> ResourceURI {
        return ResourceURI(comicId)
    }
}
