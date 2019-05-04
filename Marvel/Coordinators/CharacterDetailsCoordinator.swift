//
//  CharacterDetailsCoordinator.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class CharacterDetailsCoordinator {
    
    // MARK: - Properties
    
    private let router: Router
    private let comicUseCase: ComicUseCase
    private let character: CharacterViewItem
    
    // MARK: - Init / Deinit
    
    init(
        router: Router,
        comicUseCase: ComicUseCase,
        character: CharacterViewItem
    ) {
        self.router = router
        self.comicUseCase = comicUseCase
        self.character = character
    }
}

// MARK: - Coordinator

extension CharacterDetailsCoordinator: Coordinator {
    func start() {
        let controller = CharacterDetailViewController.instantiate()
        controller.viewModel = CharacterDetailViewModel(comicUseCase: comicUseCase, character: character)
        router.push(controller, animated: true, completion: nil)
    }
}
