//
//  ObjectBuilder.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation
import RealmSwift

extension Object {
    static func build<Entity: Object>(_ builder: (Entity) -> Void) -> Entity {
        let entity = Entity()
        builder(entity)
        return entity
    }
}
