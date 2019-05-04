//
//  UIBarButtonItem.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(title: String = "") {
        self.init()
        self.title = title
    }
}
