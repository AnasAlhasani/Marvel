//
//  MediaTableCell.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class MediaTableCell: UITableViewCell {
    // MARK: Outlets

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!

    // MARK: Properties

    private lazy var dataSource: CollectionViewDataSource = .make(
        collectionView: collectionView,
        cellType: MediaCollectionCell.self
    )
}

// MARK: CellConfigurable

extension MediaTableCell: CellConfigurable {
    func configure(with item: CharacterDetailsItem) {
        titleLabel.text = item.type.title
        dataSource.append(item.state.items, toSection: 0)
    }
}
