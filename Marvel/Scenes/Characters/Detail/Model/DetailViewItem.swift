//
//  DetailViewItem.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

struct DetailViewItem {
    let type: Type
    let state: State<ComicViewItem>
    
    init(type: Type, state: State<ComicViewItem> = .loading) {
        self.type = type
        self.state = state
    }
}

extension DetailViewItem {
    enum `Type`: String {
        case comics
        case series
        
        var title: String {
            return rawValue.capitalized
        }
    }
}
