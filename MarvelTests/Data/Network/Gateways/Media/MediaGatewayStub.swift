//
//  MediaGatewayStub.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation
@testable import Marvel

final class MediaGatewayStub: MediaGateway {
    var parameter: MarvelParameter<MediaParameter>!
    var publisher: AnyPublisher<MediaPaginator, Error>!
    var callCount = 0

    func loadMediaItems(
        with parameter: MarvelParameter<MediaParameter>
    ) -> AnyPublisher<MediaPaginator, Error> {
        self.parameter = parameter
        callCount += 1
        return publisher
    }
}
