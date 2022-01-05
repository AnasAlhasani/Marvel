//
//  UIViewController.swift
//  Marvel
//
//  Created by Anas Alhasani on 29/07/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let identifier = String(describing: self)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Couldn't instantiate view controller with identifier: \(identifier)")
        }
        return viewController
    }
}

extension UIViewController {
    func present<T: UIViewController>(
        _ viewController: T,
        animated: Bool = true,
        modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
        completion: (() -> Void)? = nil
    ) {
        viewController.modalPresentationStyle = modalPresentationStyle
        present(viewController, animated: animated, completion: completion)
    }

    func show<T: UIViewController>(
        _ viewController: T,
        animated: Bool = true
    ) {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = ""
        navigationItem.backBarButtonItem = barButtonItem
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func dismissView(animated: Bool = true) {
        guard let navigationController = navigationController else {
            dismiss(animated: animated)
            return
        }

        guard navigationController.viewControllers.count > 1 else {
            return navigationController.dismiss(animated: animated)
        }

        navigationController.popViewController(animated: animated)
    }
}
