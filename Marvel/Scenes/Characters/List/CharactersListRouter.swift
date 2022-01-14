//
//  CharactersListRouter.swift
//  Marvel
//
//  Created by Anas Alhasani on 29/07/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import UIKit

protocol CharactersListRoutable {
    func showDetails(for item: CharacterItem)
    func showSearch()
    func dismissSearch()
}

struct CharactersListRouter {
    private let factory: ViewFactory
    private weak var context: UIViewController?

    init(
        factory: ViewFactory,
        context: UIViewController?
    ) {
        self.factory = factory
        self.context = context
    }
}

extension CharactersListRouter: CharactersListRoutable {
    func showDetails(for item: CharacterItem) {
        context?.show(factory.makeCharacterDetailsView(for: item))
    }

    func showSearch() {
        context?.show(factory.makeCharactersSearchView())
    }

    func dismissSearch() {
        context?.dismissView()
    }
}
