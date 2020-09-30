//
//  Environment.swift
//  Marvel
//
//  Created by Anas Alhasani on 10/1/20.
//  Copyright © 2020 Anas Alhasani. All rights reserved.
//

import Foundation

enum Environment {
    case debug
    case release
}

var environment: Environment {
    #if DEBUG
        return .debug
    #else
        return .release
    #endif
}
