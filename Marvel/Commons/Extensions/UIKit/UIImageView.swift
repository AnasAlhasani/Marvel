//
//  UIImageView.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Kingfisher
import UIKit

extension UIImageView {
    func download(image url: URL?, placeholder: ImageAsset? = nil) {
        guard let url = url else { return }
        kf.indicatorType = .activity
        kf.setImage(with: url, placeholder: placeholder?.image)
    }
}
