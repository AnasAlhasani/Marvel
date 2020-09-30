//
//  Configuration .swift
//  Marvel
//
//  Created by Anas Alhasani on 10/1/20.
//  Copyright © 2020 Anas Alhasani. All rights reserved.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

// swiftlint:disable force_try
// swiftlint:disable force_unwrapping
extension Configuration {
    static let baseURL = URL(string: try! value(for: "BASE_URL"))!
    static let publicKey: String = try! value(for: "PUBLIC_KEY")
    static let privateKey: String = try! value(for: "PRIVATE_KEY")
}
