//
//  Configuration.swift
//  Marvel
//
//  Created by Anas Alhasani on 10/1/20.
//  Copyright © 2020 Anas Alhasani. All rights reserved.
//

import Foundation

// MARK: - Configuration

enum Config {
    private static func value<T: LosslessStringConvertible>(for key: Key) -> T {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key.rawValue) else {
            fatalError("Missing configuration key: \(key)")
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            // swiftlint:disable fallthrough
            guard let value = T(string) else { fallthrough }
            return value
        default:
            fatalError("Invalid configuration value")
        }
    }

    private static func value(for key: Key) -> URL {
        guard let url = URL(string: value(for: key)) else {
            fatalError("Invalid url configuration value for key: \(key.rawValue)")
        }
        return url
    }
}

// MARK: - Keys

extension Config {
    enum Key: String {
        case apiURL = "BASE_URL"
        case publicKey = "PUBLIC_KEY"
        case privateKey = "PRIVATE_KEY"
    }
}

// MARK: - Values

extension Config {
    static let apiURL = URL(string: value(for: .apiURL))
    static let publicKey: String = value(for: .publicKey)
    static let privateKey: String = value(for: .privateKey)
}
