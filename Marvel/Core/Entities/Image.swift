//
//  Image.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

struct Image: Codable {
    private let path: String
    private let `extension`: String

    var url: URL? {
        URL(string: "\(path).\(`extension`)")
    }
}
