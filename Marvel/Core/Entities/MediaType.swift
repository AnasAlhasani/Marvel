//
//  MediaType.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

enum MediaType: String, CaseIterable {
    case comics
    case series

    var title: String {
        rawValue.capitalized
    }
}
