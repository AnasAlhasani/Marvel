//
//  String.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

extension String {
    var isBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespaces)
        return trimmed.isEmpty
    }

    var nilIfEmpty: String? {
        isBlank ? nil : self
    }
}
