//
//  RealmRepository.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation
import RealmSwift

final class RealmRepository<E: IdentifiableEntity>: AbstractRepository {
    func fetchAll() -> AnyPublisher<[E], Error> {
        Future { promise in
            do {
                let realm = try Realm()
                let objects = realm.objects(RealmObject.self).filter("key == %@", E.key)
                let entities: [E] = try objects.map { try $0.data.decoded() }
                promise(.success(entities))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    @discardableResult
    func save(entites: [E]) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                let realm = try Realm()
                try realm.write {
                    let objects = try entites.map { RealmObject(id: "\($0.id)", key: E.key, data: try $0.encoded()) }
                    realm.add(objects, update: .all)
                }
                promise(.success)
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
