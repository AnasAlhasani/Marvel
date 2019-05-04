//
//  ComicCollectionCell.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class ComicCollectionCell: UICollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet private weak var comicImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
}

// MARK: - CellConfigurable

extension ComicCollectionCell: CellConfigurable {
    func configure(with item: ComicViewItem) {
        nameLabel.text = item.title
        comicImageView.download(image: item.imageURL)
    }
}
