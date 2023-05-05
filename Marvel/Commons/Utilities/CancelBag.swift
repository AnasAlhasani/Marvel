//
//  CancelBag.swift
//  Marvel
//
//  Created by Anas Alhasani on 05/05/2023.
//  Copyright © 2023 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation

final class CancelBag {
    var subscriptions = Set<AnyCancellable>()
    private let lock = NSRecursiveLock()

    deinit {
        cancel()
    }

    func insert(_ cancellable: AnyCancellable) {
        sync { subscriptions.insert(cancellable) }
    }

    func collect(@CancellableBuilder _ builder: () -> [AnyCancellable]) {
        sync { subscriptions.formUnion(builder()) }
    }

    func cancel() {
        sync {
            subscriptions.forEach { $0.cancel() }
            subscriptions.removeAll()
        }
    }
}

extension CancelBag {
    private func sync(action: () throws -> Void) rethrows {
        lock.lock()
        defer { lock.unlock() }
        try action()
    }
}

extension CancelBag {
    @resultBuilder
    enum CancellableBuilder {
        static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            cancellables
        }
    }
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.insert(self)
    }
}
