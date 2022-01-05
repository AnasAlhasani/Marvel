//
//  ViewModel.swift
//  Marvel
//
//  Created by Anas Alhasani on 19/12/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation

protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
