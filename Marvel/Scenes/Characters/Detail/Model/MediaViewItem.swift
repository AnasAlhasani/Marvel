//
//  MediaViewItem.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

struct MediaViewItem {
    let title: String
    let imageURL: URL?

    init(comic: Media) {
        self.title = comic.title.defaultIfEmpty
        self.imageURL = comic.thumbnail?.url
    }
}
