//
//  RealmRepositorySpy.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation
@testable import Marvel

final class RealmRepositorySpy<Entity: IdentifiableEntity>: AbstractRepository {
    var entities = [Entity]()
    var savePublisher: AnyPublisher<Void, Error>!
    var saveCallCount = 0

    var fetchCallCount = 0
    var fetchPublisher: AnyPublisher<[Entity], Error>!

    func save(entities: [Entity]) -> AnyPublisher<Void, Error> {
        saveCallCount += 1
        self.entities = entities
        return savePublisher
    }

    func fetchAll() -> AnyPublisher<[Entity], Error> {
        fetchCallCount += 1
        return fetchPublisher
    }
}
