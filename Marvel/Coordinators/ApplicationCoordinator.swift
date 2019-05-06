//
//  ApplicationCoordinator.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class ApplicationCoordinator {
    
    // MARK: - Properties
    
    let window: UIWindow
    lazy var characterUseCase: CharacterUseCase = DefaultCharacterUseCase()
    lazy var rootViewController = UINavigationController()
    lazy var router = Router(navigationController: rootViewController)
    lazy var charactersCoordinator = CharactersCoordinator(router: router, characterUseCase: characterUseCase)
    
    // MARK: - Init / Deinit
    
    init(window: UIWindow) {
        self.window = window
    }
}

// MARK: - Coordinator

extension ApplicationCoordinator: Coordinator {
    func start() {
        window.rootViewController = router.toPresentable()
        charactersCoordinator.start()
        window.makeKeyAndVisible()
    }
}
