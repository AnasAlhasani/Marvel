//
//  CharacterGatewayStub.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 14/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation
@testable import Marvel

final class CharacterGatewayStub: CharacterGateway {
    var parameter: MarvelParameter<CharacterParameter>!
    var promise: Promise<CharacterPaginator>!
    var callCount = 0
    func loadCharacters(
        with parameter: MarvelParameter<CharacterParameter>
    ) -> Promise<CharacterPaginator> {
        self.parameter = parameter
        callCount += 1
        return promise
    }
}
