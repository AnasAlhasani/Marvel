//
//  MediaType.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

enum MediaType: String, CaseIterable, Equatable {
    case comics
    case series
}

extension MediaType {
    func isHigherThan(_ type: MediaType) -> Bool {
        position.rawValue <= type.position.rawValue
    }
}

private extension MediaType {
    enum Position: Int {
        case top
        case bottom
    }

    var position: Position {
        switch self {
        case .comics: return .top
        case .series: return .bottom
        }
    }
}
