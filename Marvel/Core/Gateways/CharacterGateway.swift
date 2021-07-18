//
//  CharacterGateway.swift
//  Marvel
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation

protocol CharacterGateway {
    func loadCharacters(with parameter: MarvelParameter<CharacterParameter>) -> AnyPublisher<CharacterPaginator, Error>
}
