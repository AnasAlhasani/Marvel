//
//  RealmObject.swift
//  Marvel
//
//  Created by Anas Alhasani on 9/30/20.
//  Copyright © 2020 Anas Alhasani. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmObject: Object {
    @objc dynamic var id = ""
    @objc dynamic var key = ""
    @objc dynamic var data = Data()

    convenience init(id: String, key: String, data: Data) {
        self.init()
        self.id = id
        self.key = key
        self.data = data
    }

    override static func primaryKey() -> String? {
        "id"
    }
}
