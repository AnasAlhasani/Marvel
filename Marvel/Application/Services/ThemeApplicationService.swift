//
//  ThemeApplicationService.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class ThemeApplicationService: ApplicationService {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = Color.white.rawValue
        UINavigationBar.appearance().barTintColor = Color.primary.rawValue
        UINavigationBar.appearance().backgroundColor = Color.primary.rawValue
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes(with: .white, and: 17)

        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .semibold)],
            for: .normal
        )

        UIBarButtonItem.appearance().setTitleTextAttributes(
            titleTextAttributes(with: .white, and: 14),
            for: .normal
        )

        UISwitch.appearance().onTintColor = Color.primary.rawValue.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = Color.primary.rawValue

        UISegmentedControl.appearance().tintColor = Color.primary.rawValue

        UITableViewCell.appearance().tintColor = Color.primary.rawValue
        UITableViewCell.appearance().selectionStyle = .none

        return true
    }
}

// MARK: - Helper Methods

private extension ThemeApplicationService {
    func titleTextAttributes(with color: Color, and fontSize: CGFloat) -> [NSAttributedString.Key: Any]? {
        [
            NSAttributedString.Key.foregroundColor: color.rawValue,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        ]
    }
}
