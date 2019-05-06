//
//  ComicTableCell.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class ComicTableCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet { collectionView.register(ComicCollectionCell.self) }
    }
    
    // MARK: - Properties

    private lazy var dataSource = CollectionDataSource<ComicCollectionCell>(collectionView)
}

// MARK: - CellConfigurable

extension ComicTableCell: CellConfigurable {
    func configure(with item: DetailViewItem) {
        titleLabel.text = item.type.title
        dataSource.state = item.state
    }
}
