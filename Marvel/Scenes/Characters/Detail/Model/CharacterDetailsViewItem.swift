//
//  CharacterDetailsViewItem.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

struct CharacterDetailsViewItem {
    let type: MediaType
    var state: State<MediaViewItem>
    
    init(type: MediaType, state: State<MediaViewItem> = .loading) {
        self.type = type
        self.state = state
    }
}
