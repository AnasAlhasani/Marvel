//
//  EntityConvertible.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

// MARK: - CoreConvertible

protocol CoreConvertible {
    associatedtype Core: Decodable
    
    func asCore() -> Core
}

extension Sequence where Iterator.Element: CoreConvertible {
    func asCore() -> [Iterator.Element.Core] {
        return map { $0.asCore() }
    }
}

// MARK: - RealmRepresentable

protocol RealmRepresentable {
    associatedtype Realm: CoreConvertible
    
    func asRealm() -> Realm
}

extension Sequence where Iterator.Element: RealmRepresentable {
    func asRealm() -> [Iterator.Element.Realm] {
        return map { $0.asRealm() }
    }
}
