//
//  UIView.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

extension UIView {
    static func instantiateFromNib() -> Self {
        func instanceFromNib<T: UIView>() -> T {
            let nib = UINib(nibName: "\(self)", bundle: nil)
            guard let view = nib.instantiate(withOwner: nil, options: nil).first as? T else {
                fatalError("Could not instantiate view \(self)")
            }
            return view
        }

        return instanceFromNib()
    }
}
