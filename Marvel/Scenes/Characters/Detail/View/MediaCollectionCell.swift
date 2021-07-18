//
//  MediaCollectionCell.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class MediaCollectionCell: UICollectionViewCell {
    // MARK: - Outlets

    @IBOutlet private var comicImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
}

// MARK: - CellConfigurable

extension MediaCollectionCell: CellConfigurable {
    func configure(with item: CharacterDetailsItem.MediaItem) {
        nameLabel.text = item.title
        comicImageView.download(image: item.imageURL)
    }
}
