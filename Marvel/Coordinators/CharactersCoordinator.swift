//
//  CharactersCoordinator.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class CharactersCoordinator {
    // MARK: Properties

    private let router: Router
    private let core: AppCore

    // MARK: Init / Deinit

    init(
        router: Router,
        core: AppCore
    ) {
        self.router = router
        self.core = core
    }
}

// MARK: - Coordinator

extension CharactersCoordinator: Coordinator {
    func start() {
        let controller = CharactersViewController.instantiate()
        controller.viewModel = CharactersViewModel(
            coordinator: self,
            characterUseCase: core.characterUseCase(),
            throttler: core.throttler()
        )
        router.push(controller, animated: true, completion: nil)
    }
}

// MARK: - CharactersViewControllerDelegate

extension CharactersCoordinator: CharactersCoordinatorDelegate {
    func didTapSearch() {
        let viewModel = CharactersViewModel(
            coordinator: self,
            characterUseCase: core.characterUseCase(),
            throttler: core.throttler()
        )
        let coordinator = SearchCoordinator(router: router, viewModel: viewModel)
        coordinator.start()
    }

    func didTapCancelSearch() {
        router.pop()
    }

    func didSelect(character: CharacterViewItem) {
        let coordinator = CharacterDetailsCoordinator(
            router: router,
            mediaUseCase: core.mediaUseCase(),
            character: character
        )
        coordinator.start()
    }
}
