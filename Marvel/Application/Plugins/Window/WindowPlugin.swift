//
//  WindowPlugin.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

protocol WindowDelegate: AnyObject {
    var window: UIWindow? { get set }
}

final class WindowPlugin {
    private weak var delegate: WindowDelegate?
    private let factory: ViewFactory

    init(delegate: WindowDelegate?, factory: ViewFactory) {
        self.delegate = delegate
        self.factory = factory
    }
}

extension WindowPlugin: ApplicationPlugin {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = factory.makeRootView()
        window.makeKeyAndVisible()
        delegate?.window = window
        return true
    }
}

extension ApplicationPluggableDelegate: WindowDelegate {}
