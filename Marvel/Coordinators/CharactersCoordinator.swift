//
//  CharactersCoordinator.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class CharactersCoordinator {
    
    // MARK: - Properties

    private let router: Router
    private let characterUseCase: CharacterUseCase
    private lazy var comicUseCase: ComicUseCase = APIComicUseCase()
    
    // MARK: - Init / Deinit
    
    init(router: Router, characterUseCase: CharacterUseCase) {
        self.router = router
        self.characterUseCase = characterUseCase
    }
}

// MARK: - Coordinator

extension CharactersCoordinator: Coordinator {
    func start() {
        let controller = CharactersViewController.instantiate()
        controller.viewModel = CharactersViewModel(coordinator: self, characterUseCase: characterUseCase)
        router.push(controller, animated: true, completion: nil)
    }
}

// MARK: - CharactersViewControllerDelegate

extension CharactersCoordinator: CharactersCoordinatorDelegate {
    func didTapSearch() {
        let viewModel = CharactersViewModel(coordinator: self, characterUseCase: characterUseCase)
        let coordinator = SearchCoordinator(router: router, viewModel: viewModel)
        coordinator.start()
    }
    
    func didTapCancelSearch() {
        router.pop()
    }
    
    func didSelect(character: CharacterViewItem) {
        let coordinator = CharacterDetailsCoordinator(
            router: router,
            comicUseCase: comicUseCase,
            character: character
        )
        coordinator.start()
    }
}
