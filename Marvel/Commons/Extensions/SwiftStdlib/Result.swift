//
//  Result.swift
//  Marvel
//
//  Created by Anas Alhasani on 27/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation

extension Result {
    var error: Error? {
        switch self {
        case .success:
            return nil
        case let .failure(error):
            return error
        }
    }
}

extension Result where Success == Void {
    static var success: Self {
        .success(())
    }
}
