//
//  ThemePlugin.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

struct ThemePlugin {
    private let theme: Theme

    init(theme: Theme) {
        self.theme = theme
    }
}

extension ThemePlugin: ApplicationPlugin {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        theme.apply(for: application.currentWindow)
        return true
    }
}
