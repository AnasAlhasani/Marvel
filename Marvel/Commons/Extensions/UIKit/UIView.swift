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

    static func loadView(form nibName: String) -> UIView {
        let nib = UINib(nibName: nibName, bundle: nil)
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? UIView else {
            fatalError("Could not instantiate view \(nibName)")
        }
        return view
    }

    func loadFromNib() {
        guard let subView = UINib(nibName: "\(type(of: self))", bundle: nil)
            .instantiate(withOwner: self, options: nil).first as? UIView
        else { return }

        subView.frame = bounds
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(subView)
    }
}
