//
//  RepositoryProtocol.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

protocol RepositoryProtocol {
    associatedtype Entity
    
    @discardableResult
    func save(entites: [Entity]) -> Promise<Void>
    func fetchAll() -> Promise<[Entity]>
}
