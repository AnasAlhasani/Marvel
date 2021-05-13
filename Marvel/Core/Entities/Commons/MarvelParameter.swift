//
//  MarvelParameter.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import CryptoSwift
import Foundation

struct MarvelParameter<Value: Parameter>: Parameter {
    private(set) var timestamp: String
    private(set) var hash: String
    private(set) var apiKey: String
    private(set) var value: Value

    init(
        _ value: Value,
        timestamp: String = "\(Date().timeIntervalSince1970)",
        publicKey: String = Config.publicKey,
        privateKey: String = Config.privateKey
    ) {
        self.timestamp = timestamp
        self.hash = "\(timestamp)\(privateKey)\(publicKey)".md5()
        self.apiKey = publicKey
        self.value = value
    }
}

// MARK: - Encodable

extension MarvelParameter: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(hash, forKey: .hash)
        try container.encode(apiKey, forKey: .apiKey)
        try value.encode(to: encoder)
    }

    enum CodingKeys: String, CodingKey {
        case timestamp = "ts"
        case apiKey = "apikey"
        case hash
        case value
    }
}
