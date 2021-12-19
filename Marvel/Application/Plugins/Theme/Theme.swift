//
//  Theme.swift
//  Marvel
//
//  Created by Anas Alhasani on 19/12/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import UIKit

protocol Theme {}

extension Theme {
    func apply(for window: UIWindow?) {
        window?.tintColor = Colors.primary.color
        apply()
    }
}

private extension Theme {
    func apply() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        navigationBar.tintColor = Colors.white.color
        navigationBar.barTintColor = Colors.primary.color
        navigationBar.backgroundColor = Colors.primary.color
        navigationBar.titleTextAttributes = titleTextAttributes(with: Colors.white, and: 17)

        let barButtonItem = UIBarButtonItem.appearance()
        barButtonItem.setTitleTextAttributes(
            titleTextAttributes(with: Colors.white, and: 14),
            for: .normal
        )

        let collectionView = UICollectionView.appearance()
        collectionView.backgroundColor = Colors.gray.color

        let tableView = UITableView.appearance()
        tableView.separatorStyle = .none
        tableView.backgroundColor = Colors.darkGray.color

        let tableViewCell = UITableViewCell.appearance()
        tableViewCell.tintColor = Colors.primary.color
        tableViewCell.selectionStyle = .none
    }

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

struct AppTheme: Theme {}
