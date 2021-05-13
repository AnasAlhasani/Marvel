//
//  Entity.swift
//  Marvel
//
//  Created by Anas Alhasani on 9/30/20.
//  Copyright © 2020 Anas Alhasani. All rights reserved.
//

import Foundation

protocol Entity: Codable, Equatable {}
protocol IdentifiableEntity: Entity, Identifiable where RawIdentifier == Int {}

extension Entity {
    static var key: String { String(describing: self) }
}
