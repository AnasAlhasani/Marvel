//
//  ThrottlerSpy.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 15/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation
@testable import Marvel

final class ThrottlerSpy: Throttler {
    var completion: (() -> Void)!
    var callCount = 0

    func throttle(_ block: @escaping () -> Void) {
        callCount += 1
        completion = block
    }
}
