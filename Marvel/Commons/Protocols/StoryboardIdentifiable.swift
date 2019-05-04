//
//  StoryboardIdentifiable.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let identifier = "\(self)"
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Couldn't instantiate view controller with identifier \(identifier) ")
        }
        return viewController
    }
}

extension UIViewController: StoryboardIdentifiable { }
