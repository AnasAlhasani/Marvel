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

    func loadFromNib() {
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: nil)
        // swiftlint:disable:next force_cast
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
