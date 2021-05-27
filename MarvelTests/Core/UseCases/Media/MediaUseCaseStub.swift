//
//  MediaUseCaseStub.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation
@testable import Marvel

final class MediaUseCaseStub: MediaUseCase {
    var parameter: MediaParameter!
    var publisher: AnyPublisher<MediaPaginator, Error>!
    var callCount = 0

    func loadMediaItems(with parameter: MediaParameter) -> AnyPublisher<MediaPaginator, Error> {
        self.parameter = parameter
        callCount += 1
        return publisher
    }
}
