//
//  ApplicationCoordinatorService.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class ApplicationCoordinatorService: ApplicationService {
    // MARK: Properties

    private var window: UIWindow?
    private let router: AppRouter

    // MARK: Init

    init(
        with window: UIWindow?,
        router: AppRouter
    ) {
        self.window = window
        self.router = router
    }

    // MARK: ApplicationService

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = router.charactersListView()
        window?.makeKeyAndVisible()
        return true
    }
}
