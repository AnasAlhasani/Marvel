//
//  CharactersCoordinatorDelegateSpy.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 15/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation
@testable import Marvel

final class CharactersCoordinatorDelegateSpy: CharactersCoordinatorDelegate {
    var didTapSearchCallCount = 0
    var didTapCancelSearchCallCount = 0
    var didSelectCharacterCallCount = 0
    var character: CharacterViewItem!

    func didTapSearch() {
        didTapSearchCallCount += 1
    }

    func didTapCancelSearch() {
        didTapCancelSearchCallCount += 1
    }

    func didSelect(character: CharacterViewItem) {
        didSelectCharacterCallCount += 1
        self.character = character
    }
}
