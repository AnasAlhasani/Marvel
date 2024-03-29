//
//  CharactersCell.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

class CharactersCell: UITableViewCell {
    // MARK: Outlets

    @IBOutlet private var characterImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!

    // MARK: Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        characterImageView.cancelDownloading()
    }
}

// MARK: CellConfigurable

extension CharactersCell: CellConfigurable {
    func configure(with item: CharacterItem) {
        characterImageView.download(image: item.imageURL)
        nameLabel.text = item.name
    }
}
