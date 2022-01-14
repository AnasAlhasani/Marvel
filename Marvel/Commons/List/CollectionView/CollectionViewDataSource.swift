//
//  CollectionViewDataSource.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import UIKit

typealias CollectionViewCell = UICollectionViewCell & CellConfigurable
typealias CollectionViewDataSource<Item: Hashable> = UICollectionViewDiffableDataSource<ListSection, Item>

extension UICollectionViewDiffableDataSource {
    static func make<Cell: CollectionViewCell>(
        collectionView: UICollectionView,
        cellType: Cell.Type = Cell.self
    ) -> UICollectionViewDiffableDataSource where Cell.Item == ItemIdentifierType {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell: Cell = collectionView.dequeueReusableCell(at: indexPath)
            cell.configure(with: item)
            return cell
        }
    }

    func append(
        _ items: [ItemIdentifierType],
        toSection section: SectionIdentifierType,
        scheduler: AnyScheduler<DispatchQueue> = .main
    ) {
        scheduler.schedule {
            var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
            self.apply(snapshot, animatingDifferences: true)
        }
    }
}
