//
//  Configuration.swift
//  Marvel
//
//  Created by Anas Alhasani on 10/1/20.
//  Copyright © 2020 Anas Alhasani. All rights reserved.
//

import XcodeConfig

enum Config {
    @XcodeConfig(key: "API_URL") static var apiURL: String
    @XcodeConfig(key: "PUBLIC_KEY") static var publicKey: String
    @XcodeConfig(key: "PRIVATE_KEY") static var privateKey: String
    @XcodeConfig(key: "PAGE_LIMIT") static var pageLimit: Int
}
