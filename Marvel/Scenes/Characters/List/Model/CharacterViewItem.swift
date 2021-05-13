//
//  CharacterViewItem.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

struct CharacterViewItem {
    let id: MarvelCharacter.ID
    let imageURL: URL?
    let name: String
    let description: String
    var nameTitle: String { L10n.Character.name }
    var descriptionTitle: String { L10n.Character.description }

    init(_ character: MarvelCharacter) {
        self.id = character.id
        self.name = character.name.defaultIfEmpty
        self.description = character.description.defaultIfEmpty
        self.imageURL = character.thumbnail?.url
    }
}
