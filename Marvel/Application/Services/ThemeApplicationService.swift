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
        UINavigationBar.appearance().tintColor = Colors.white.color
        UINavigationBar.appearance().barTintColor = Colors.primary.color
        UINavigationBar.appearance().backgroundColor = Colors.primary.color
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes(with: Colors.white, and: 17)

        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .semibold)],
            for: .normal
        )

        UIBarButtonItem.appearance().setTitleTextAttributes(
            titleTextAttributes(with: Colors.white, and: 14),
            for: .normal
        )

        UISwitch.appearance().onTintColor = Colors.primary.color.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = Colors.primary.color

        UISegmentedControl.appearance().tintColor = Colors.primary.color

        UITableViewCell.appearance().tintColor = Colors.primary.color
        UITableViewCell.appearance().selectionStyle = .none

        return true
    }
}

// MARK: - Helper Methods

private extension ThemeApplicationService {
    func titleTextAttributes(
        with colorAsset: ColorAsset,
        and fontSize: CGFloat
    ) -> [NSAttributedString.Key: Any]? {
        [
            NSAttributedString.Key.foregroundColor: colorAsset.color,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        ]
    }
}
