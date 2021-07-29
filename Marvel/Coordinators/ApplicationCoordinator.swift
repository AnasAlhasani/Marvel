//
//  ApplicationCoordinator.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class ApplicationCoordinator {
    // MARK: Properties

    private let window: UIWindow
    private let core: AppCore

    private lazy var navigationController = UINavigationController()
    private lazy var router = { Router(navigationController: navigationController) }()
    private lazy var charactersCoordinator = CharactersCoordinator(
        router: router,
        core: core
    )

    // MARK: Init / Deinit

    init(window: UIWindow, core: AppCore) {
        self.window = window
        self.core = core
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
