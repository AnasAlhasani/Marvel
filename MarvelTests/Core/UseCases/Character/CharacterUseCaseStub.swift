//
//  CharacterUseCaseStub.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation
@testable import Marvel

final class CharacterUseCaseStub: CharacterUseCase {
    var parameter: CharacterParameter!
    var publisher: AnyPublisher<CharacterPaginator, Error>!
    var callCount = 0

    func loadCharacters(with parameter: CharacterParameter) -> AnyPublisher<CharacterPaginator, Error> {
        self.parameter = parameter
        callCount += 1
        return publisher
    }
}
