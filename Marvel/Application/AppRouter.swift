//
//  AppRouter.swift
//  Marvel
//
//  Created by Anas Alhasani on 29/07/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import UIKit

protocol AppRouter {
    func charactersListView() -> UIViewController
    func charactersSearchView() -> UIViewController
    func characterDetailsView(for item: CharacterItem) -> UIViewController
}

struct DefaultAppRouter {
    private let core: AppCore

    init(core: AppCore) {
        self.core = core
    }
}

extension DefaultAppRouter: AppRouter {
    func charactersListView() -> UIViewController {
        let view = CharactersViewController.instantiate()
        let router = CharactersListRouter(router: self, viewController: view)
        let viewModel = CharactersViewModel(
            router: router,
            characterUseCase: core.characterUseCase(),
            throttler: core.throttler()
        )

        view.viewModel = viewModel
        return UINavigationController(rootViewController: view)
    }

    func charactersSearchView() -> UIViewController {
        let view = SearchViewController.instantiate()
        let router = CharactersListRouter(router: self, viewController: view)
        let viewModel = CharactersViewModel(
            router: router,
            characterUseCase: core.characterUseCase(),
            throttler: core.throttler()
        )

        view.viewModel = viewModel
        return view
    }

    func characterDetailsView(for item: CharacterItem) -> UIViewController {
        let view = CharacterDetailViewController.instantiate()
        let viewModel = CharacterDetailViewModel(
            mediaUseCase: core.mediaUseCase(),
            character: item
        )
        view.viewModel = viewModel
        return view
    }
}
