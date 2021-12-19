//
//  AppDelegate.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: PluggableApplicationDelegate {
    override func services() -> [ApplicationService] {
        [
            ApplicationCoordinatorService(with: window, factory: AppRoot.viewFactory),
            ThemeApplicationService()
        ]
    }
}

private enum AppRoot {
    static let core = DefaultAppCore()
    static let viewFactory = DefaultViewFactory(core: core)
}
