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
    private let router: AppRouter
    private weak var viewController: UIViewController?

    init(
        router: AppRouter,
        viewController: UIViewController?
    ) {
        self.router = router
        self.viewController = viewController
    }
}

extension CharactersListRouter: CharactersListRoutable {
    func showDetails(for item: CharacterItem) {
        viewController?.show(router.characterDetailsView(for: item))
    }

    func showSearch() {
        viewController?.show(router.charactersSearchView())
    }

    func dismissSearch() {
        viewController?.dismissView()
    }
}
