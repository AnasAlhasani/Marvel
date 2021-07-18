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
