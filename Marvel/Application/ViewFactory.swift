//
//  ViewFactory.swift
//  Marvel
//
//  Created by Anas Alhasani on 29/07/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import UIKit

protocol ViewFactory {
    func makeRootView() -> UIViewController
    func makeCharactersListView() -> UIViewController
    func makeCharactersSearchView() -> UIViewController
    func makeCharacterDetailsView(for item: CharacterItem) -> UIViewController
}

struct DefaultViewFactory: ViewFactory {
    private let core: AppCore

    init(core: AppCore) {
        self.core = core
    }
}

extension DefaultViewFactory {
    func makeRootView() -> UIViewController {
        makeCharactersListView()
    }
}

extension DefaultViewFactory {
    func makeCharactersListView() -> UIViewController {
        let view = CharactersViewController.instantiate()
        let router = CharactersListRouter(factory: self, context: view)
        let viewModel = CharactersViewModel(
            router: router,
            useCase: core.characterUseCase(),
            scheduler: core.scheduler()
        )

        view.viewModel = viewModel
        return UINavigationController(rootViewController: view)
    }

    func makeCharactersSearchView() -> UIViewController {
        let view = SearchViewController.instantiate()
        let router = CharactersListRouter(factory: self, context: view)
        let viewModel = CharactersViewModel(
            router: router,
            useCase: core.characterUseCase(),
            scheduler: core.scheduler()
        )

        view.viewModel = viewModel
        return view
    }

    func makeCharacterDetailsView(for item: CharacterItem) -> UIViewController {
        let view = CharacterDetailsViewController.instantiate()
        let viewModel = CharacterDetailsViewModel(
            useCase: core.mediaUseCase(),
            character: item
        )
        view.viewModel = viewModel
        return view
    }
}
