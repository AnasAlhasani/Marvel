//
//  CollectionViewDataSource.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

typealias CollectionViewCell = CellConfigurable & UICollectionViewCell
typealias CollectionViewDataSourceDelegate = UICollectionViewDataSource & UICollectionViewDelegate

final class CollectionViewDataSource<Cell: CollectionViewCell>: NSObject, CollectionViewDataSourceDelegate {
    // MARK: Types

    typealias DidSelectHandler = (IndexPath) -> Void
    typealias PagingHandler = (Int) -> Void

    // MARK: Properties

    private let collectionView: UICollectionView

    var state: State<Cell.Item> = .loading {
        didSet { collectionView.display(state) }
    }

    // MARK: Handlers

    var didSelectHandler: DidSelectHandler?
    var pagingHandler: PagingHandler?

    // MARK: Init / Deinit

    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        state.items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: Cell = collectionView.dequeueReusableCell(at: indexPath)
        let item = state.items[indexPath.row]
        cell.configure(with: item)
        if case let .paging(_, nextOffset) = state, indexPath.row == state.items.count - 1 {
            pagingHandler?(nextOffset)
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectHandler?(indexPath)
    }
}
