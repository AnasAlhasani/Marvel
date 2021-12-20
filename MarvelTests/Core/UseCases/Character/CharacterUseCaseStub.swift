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
    var publisher: CharacterPublisher!
    var callCount = 0

    func loadCharacters(with parameter: CharacterParameter) -> CharacterPublisher {
        self.parameter = parameter
        callCount += 1
        return publisher
    }
}
