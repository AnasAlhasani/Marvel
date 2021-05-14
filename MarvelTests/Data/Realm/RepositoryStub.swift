//
//  RepositoryStub.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation

@testable import Marvel

final class RepositoryStub<Entity: IdentifiableEntity>: AbstractRepository {
    var entites = [Entity]()
    var savePromise: Promise<Void>!
    var saveCallCount = 0
    var fetchCallCount = 0
    var fetchPromise: Promise<[Entity]>!

    @discardableResult
    func save(entites: [Entity]) -> Promise<Void> {
        self.entites = entites
        saveCallCount += 1
        return savePromise
    }

    func fetchAll() -> Promise<[Entity]> {
        fetchCallCount += 1
        return fetchPromise
    }
}
