//
//  AbstractRepository.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation

protocol AbstractRepository {
    associatedtype Entity

    @discardableResult
    func save(entites: [Entity]) -> AnyPublisher<Void, Error>
    func fetchAll() -> AnyPublisher<[Entity], Error>
}

extension AbstractRepository {
    func eraseToAnyRepository() -> AnyRepository<Entity> {
        .init(self)
    }
}

final class AnyRepository<E>: AbstractRepository {
    private typealias SaveAction = ([E]) -> AnyPublisher<Void, Error>
    private typealias FetchAllAction = () -> AnyPublisher<[E], Error>

    private let saveAction: SaveAction
    private let fetchAllAction: FetchAllAction

    init<R: AbstractRepository>(_ repository: R) where R.Entity == E {
        self.saveAction = repository.save
        self.fetchAllAction = repository.fetchAll
    }

    @discardableResult
    func save(entites: [E]) -> AnyPublisher<Void, Error> {
        saveAction(entites)
    }

    func fetchAll() -> AnyPublisher<[E], Error> {
        fetchAllAction()
    }
}
