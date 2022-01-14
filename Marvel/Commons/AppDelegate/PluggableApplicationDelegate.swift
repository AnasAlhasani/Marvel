//
//  PluggableApplicationDelegate.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

// swiftlint:disable reduce_boolean

import UIKit

// MARK: - ApplicationPlugin

protocol ApplicationPlugin {
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool

    func applicationWillEnterForeground(_ application: UIApplication)
    func applicationDidEnterBackground(_ application: UIApplication)
    func applicationDidBecomeActive(_ application: UIApplication)
    func applicationWillResignActive(_ application: UIApplication)

    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication)
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication)

    func applicationWillTerminate(_ application: UIApplication)
    func applicationDidReceiveMemoryWarning(_ application: UIApplication)

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
}

extension ApplicationPlugin {
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {}
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {}

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {}
}

// MARK: - ApplicationPluggableDelegate

class ApplicationPluggableDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private(set) lazy var pluginInstances: [ApplicationPlugin] = { plugins() }()

    override init() {
        super.init()
        _ = pluginInstances
    }

    func plugins() -> [ApplicationPlugin] { [] }
}

extension ApplicationPluggableDelegate {
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        pluginInstances.reduce(true) {
            $0 && $1.application(application, willFinishLaunchingWithOptions: launchOptions)
        }
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        pluginInstances.reduce(true) {
            $0 && $1.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }
}

extension ApplicationPluggableDelegate {
    func applicationWillEnterForeground(_ application: UIApplication) {
        pluginInstances.forEach { $0.applicationWillEnterForeground(application) }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        pluginInstances.forEach { $0.applicationDidEnterBackground(application) }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        pluginInstances.forEach { $0.applicationDidBecomeActive(application) }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        pluginInstances.forEach { $0.applicationWillResignActive(application) }
    }
}

extension ApplicationPluggableDelegate {
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        pluginInstances.forEach { $0.applicationProtectedDataWillBecomeUnavailable(application) }
    }

    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        pluginInstances.forEach { $0.applicationProtectedDataDidBecomeAvailable(application) }
    }
}

extension ApplicationPluggableDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        pluginInstances.forEach { $0.applicationWillTerminate(application) }
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        pluginInstances.forEach { $0.applicationDidReceiveMemoryWarning(application) }
    }
}

extension ApplicationPluggableDelegate {
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        pluginInstances.forEach {
            $0.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        pluginInstances.forEach {
            $0.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
        }
    }
}

// MARK: - Helpers

extension UIApplication {
    var currentWindow: UIWindow? { windows.first(where: \.isKeyWindow) }
}
