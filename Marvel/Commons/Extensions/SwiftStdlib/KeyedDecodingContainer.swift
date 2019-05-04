//
//  KeyedDecodingContainer.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    
    // MARK: - String
    
    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        return try? decode(String.self, forKey: key)
    }
    
    // MARK: - Int
    
    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        return try? decode(Int.self, forKey: key)
    }
    
    // MARK: - Bool
    
    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        return try? decode(Bool.self, forKey: key)
    }
    
    // MARK: - Double
    
    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        return try? decode(Double.self, forKey: key)
    }
    
    // MARK: - URL
    
    func decodeIfPresent(_ type: URL.Type, forKey key: K) throws -> URL? {
        return try? decode(URL.self, forKey: key)
    }
    
    // MARK: - Date
    
    func decodeIfPresent(_ type: Date.Type, forKey key: K) throws -> Date? {
        return try? decode(Date.self, forKey: key)
    }
    
    // MARK: - Decodable Property
    
    func decodeIfPresent<T: Decodable>(_ type: T.Type, forKey key: K) throws -> T? {
        return try? decode(T.self, forKey: key)
    }
    
}
