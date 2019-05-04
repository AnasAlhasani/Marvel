//
//  Router.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class Router: NSObject {
    
    // MARK: - Properties
    
    private var completions: [UIViewController : () -> Void]
    unowned let navigationController: UINavigationController
    
    var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }
    
    // MARK: - Init / Deinit
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.completions = [:]
        super.init()
        self.navigationController.delegate = self
    }
    
    // MARK: - Helper Methods
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

// MARK: - Routable

extension Router: Routable {
    func toPresentable() -> UIViewController {
        return navigationController
    }
    
    func present(_ module: Showable, animated: Bool) {
        navigationController.present(module.toShowable(), animated: animated, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    func push(_ module: Showable, animated: Bool = true, completion: (() -> Void)? = nil) {
        let controller = module.toShowable()
        
        guard controller is UINavigationController == false else { return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        
        let barButtonItem = UIBarButtonItem()

        navigationController.navigationItem.backBarButtonItem = barButtonItem
        controller.navigationItem.backBarButtonItem = barButtonItem
        
        navigationController.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension Router: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(poppedViewController)
        else { return }
        runCompletion(for: poppedViewController)
    }
}
