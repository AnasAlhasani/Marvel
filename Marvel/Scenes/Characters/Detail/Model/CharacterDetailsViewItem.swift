//
//  CharacterDetailsViewItem.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

struct CharacterDetailsViewItem: Equatable {
    private let type: MediaType
    var state: State<MediaItem>
    var title: String {
        switch type {
        case .comics:
            return L10n.Character.comics
        case .series:
            return L10n.Character.series
        }
    }

    init(
        type: MediaType,
        state: State<MediaItem> = .loading
    ) {
        self.type = type
        self.state = state
    }
}

extension CharacterDetailsViewItem {
    struct MediaItem: Equatable {
        private(set) var model: Media

        var title: String { model.title.defaultIfEmpty }
        var imageURL: URL? { model.thumbnail?.url }

        init(model: Media) {
            self.model = model
        }
    }
}
