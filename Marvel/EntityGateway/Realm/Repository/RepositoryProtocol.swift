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
    
    func fetchAll() -> Promise<[Entity]>
    func save(entites: [Entity]) -> Promise<Void>
}
