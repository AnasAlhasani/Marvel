//
//  RealmRepository.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmRepository<T: RealmRepresentable>: RepositoryProtocol where T == T.Realm.Core, T.Realm: Object {

    func fetchAll() -> Promise<[T]> {
        return Promise<[T]> { fullfill, reject in
            do {
                let realm = try Realm()
                let objects = realm.objects(T.Realm.self)
                fullfill(objects.asCore())
            } catch {
                reject(error)
            }
        }
    }
    
    func save(entites: [T]) -> Promise<Void> {
        return Promise<Void> { fullfill, reject in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(entites.asRealm(), update: true)
                }
                fullfill(())
            } catch {
                reject(error)
            }
        }
    }
}
