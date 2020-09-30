//
//  AbstractRepository.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

protocol AbstractRepository {
    associatedtype Entity
    
    @discardableResult
    func save(entites: [Entity]) -> Promise<Void>
    func fetchAll() -> Promise<[Entity]>
}

final class AnyRepository<E>: AbstractRepository {
    private typealias SaveAction = ([E]) -> Promise<Void>
    private typealias FetchAllAction = () -> Promise<[E]>
        
    private let saveAction: SaveAction
    private let fetchAllAction: FetchAllAction

    init<R: AbstractRepository>(_ repository: R) where R.Entity == E {
        self.saveAction = repository.save
        self.fetchAllAction = repository.fetchAll
    }
    
    @discardableResult
    func save(entites: [E]) -> Promise<Void> {
        saveAction(entites)
    }
    
    func fetchAll() -> Promise<[E]> {
        fetchAllAction()
    }
}
