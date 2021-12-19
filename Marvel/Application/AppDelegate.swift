//
//  AppDelegate.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

@main
final class AppDelegate: ApplicationPluggableDelegate {
    override func plugins() -> [ApplicationPlugin] {
        [
            WindowPlugin(delegate: self, factory: viewFactory),
            ThemePlugin(theme: core.theme())
        ]
    }
}

private enum AppRoot {
    static let core = DefaultAppCore()
    static let viewFactory = DefaultViewFactory(core: core)
}

private extension UIApplicationDelegate {
    var core: AppCore { AppRoot.core }
    var viewFactory: ViewFactory { AppRoot.viewFactory }
}
