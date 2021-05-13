//
//  MediaType.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

enum MediaType: String {
    case comics
    case series

    var title: String {
        switch self {
        case .comics:
            return L10n.Character.comics
        case .series:
            return L10n.Character.series
        }
    }
}
