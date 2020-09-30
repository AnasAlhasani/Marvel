//
//  MarvelParameter.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation
import CryptoSwift

struct VoidParameter: Encodable { }

struct MarvelParameter<Value: Encodable> {
    
    private let timestamp: String
    private let hash: String
    private let apiKey: String
    private let parameter: Value?
    
    init(
        _ parameter: Value? = nil,
        publicKey: String = Configuration.publicKey,
        privateKey: String = Configuration.privateKey
    ) {
        self.timestamp = "\(Date().timeIntervalSince1970)"
        self.hash = "\(timestamp)\(privateKey)\(publicKey)".md5()
        self.apiKey = publicKey
        self.parameter = parameter
    }
}

// MARK: - Encodable

extension MarvelParameter: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(hash, forKey: .hash)
        try container.encode(apiKey, forKey: .apiKey)
        try parameter?.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "ts"
        case apiKey = "apikey"
        case hash
        case parameter
    }
}
