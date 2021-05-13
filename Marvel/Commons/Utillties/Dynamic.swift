//
//  Dynamic.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

final class Dynamic<Value> {
    typealias Listener = (Value) -> Void

    private var listener: Listener?

    var value: Value {
        didSet { listener?(value) }
    }

    init(_ value: Value) {
        self.value = value
    }

    func bind(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
