//
//  CellConfigurable.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

protocol CellConfigurable {
    associatedtype Item: Hashable

    func configure(with item: Item)
}
