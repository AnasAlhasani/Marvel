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
        publicKey: String = "5d94fab0240e515bd064e7d9362f8e78",
        privateKey: String = "1098df006e7e6edce50211c7be6431daabee3d73"
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
