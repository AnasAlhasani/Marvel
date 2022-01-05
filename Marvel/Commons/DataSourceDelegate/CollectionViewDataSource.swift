//
//  CollectionViewDataSource.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class CollectionViewDataSource<Cell: CellConfigurable & UICollectionViewCell>: NSObject, UICollectionViewDataSource {
    // MARK: Properties

    private let collectionView: UICollectionView
    @Published private(set) var nextPage = 0
    var state: State<Cell.Item> = .loading {
        didSet { collectionView.transition(to: state) }
    }

    // MARK: Init / Deinit

    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
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
        if case let .paging(_, nextPage) = state, indexPath.row == state.items.count - 1 {
            self.nextPage = nextPage
        }
        return cell
    }
}
