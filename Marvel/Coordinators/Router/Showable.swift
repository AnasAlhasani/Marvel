//
//  Showable.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

protocol Showable {
    
    func toShowable() -> UIViewController
    
}

extension UIViewController: Showable {
    public func toShowable() -> UIViewController {
        return self
    }
}
