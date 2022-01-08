//
//  AssociatedObject.swift
//  Marvel
//
//  Created by Anas Alhasani on 08/01/2022.
//  Copyright © 2022 Anas Alhasani. All rights reserved.
//

import Foundation

protocol AssociatedObject {
    func value<T>(for key: UnsafeRawPointer) -> T?
    func setValue<T>(_ value: T?, for key: UnsafeRawPointer)
}

extension AssociatedObject {
    /// Returns the value associated with a given object for a given key, whether it is a value type or a class.
    func value<T>(for key: UnsafeRawPointer) -> T? {
        objc_getAssociatedObject(self, key) as? T
    }

    /// Sets an associated value for a given object using a given key and association policy, whether it is a value type or a class.
    func setValue<T>(_ value: T?, for key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
}

extension NSObject: AssociatedObject {}
