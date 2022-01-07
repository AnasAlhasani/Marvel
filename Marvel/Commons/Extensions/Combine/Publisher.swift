//
//  AnyPublisher.swift
//  Marvel
//
//  Created by Anas Alhasani on 26/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation

extension Publisher {
    func convertToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        map(Result.success)
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    /// The flatMapLatest operator behaves much like the standard FlatMap operator, except that whenever
    /// a new item is emitted by the source Publisher, it will unsubscribe to and stop mirroring the Publisher
    /// that was generated from the previously-emitted item, and begin only mirroring the current one.
    func flatMapLatest<T: Publisher>(
        _ transform: @escaping (Self.Output) -> T
    ) -> Publishers.SwitchToLatest<T, Publishers.Map<Self, T>> where T.Failure == Self.Failure {
        map(transform).switchToLatest()
    }
}

extension Publisher where Failure == Never {
    func bind<S: Subscriber>(to subscriber: S) -> AnyCancellable where S.Failure == Never, S.Input == Output {
        // swiftlint:disable:next trailing_closure
        handleEvents(
            receiveSubscription: { subscription in subscriber.receive(subscription: subscription) }
        ).sink { value in
            _ = subscriber.receive(value)
        }
    }
}
