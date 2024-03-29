//
//  MediaGateway.swift
//  Marvel
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation

protocol MediaGateway {
    func loadMediaItems(with parameter: MarvelParameter<MediaParameter>) -> AnyPublisher<MediaPaginator, Error>
}
