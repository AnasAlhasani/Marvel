//
//  CharactersListRouterSpy.swift
//  MarvelTests
//
//  Created by Anas Alhasani on 15/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation
@testable import Marvel

final class CharactersListRouterSpy: CharactersListRoutable {
    var showDetailsCallCount = 0
    var character: CharacterViewItem!
    var showSearchCallCount = 0
    var dismissSearchCallCount = 0

    func showDetails(for item: CharacterViewItem) {
        showDetailsCallCount += 1
        character = item
    }

    func showSearch() {
        showSearchCallCount += 1
    }

    func dismissSearch() {
        dismissSearchCallCount += 1
    }
}
