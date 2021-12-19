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
    private let factory: ViewFactory

    // MARK: Init

    init(
        with window: UIWindow?,
        factory: ViewFactory
    ) {
        self.window = window
        self.factory = factory
    }

    // MARK: ApplicationService

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = factory.makeRootView()
        window?.makeKeyAndVisible()
        return true
    }
}
