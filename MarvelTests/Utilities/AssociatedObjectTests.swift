//
//  AssociatedObjectTests.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 08/01/2022.
//  Copyright © 2022 Anas Alhasani. All rights reserved.
//

@testable import Marvel
import XCTest

final class AssociatedObjectTests: XCTestCase {
    func testObjects() {
        enum Key {
            static var value = 0
        }

        struct Value: Equatable {
            var property = 0
        }

        let owner = NSObject()
        var value = Value()
        value.property = 666

        owner.setValue(value, for: &Key.value)
        XCTAssertEqual(owner.value(for: &Key.value), value)

        owner.setValue(nil as Value?, for: &Key.value)
        XCTAssertNil(owner.value(for: &Key.value) as Value?)
    }
}
