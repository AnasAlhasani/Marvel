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
typealias CollectionViewDataSource<Item: Hashable> = UICollectionViewDiffableDataSource<AnyHashable, Item>

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

private var nextPageKey = 0

extension UICollectionView {
    typealias DataSourceSubscriber<Item: Hashable> = AnySubscriber<ListState<Item>, Never>

    private var nextPage: Int? {
        get { value(for: &nextPageKey) }
        set { setValue(newValue, for: &nextPageKey) }
    }

    var nextPagePublisher: AnyPublisher<Int, Never> {
        willDisplayCellPublisher
            .filter { [unowned self] in
                nextPage != .none && $1.row == numberOfItems(inSection: 0) - 1
            }
            .compactMap { [unowned self] _ in nextPage }
            .eraseToAnyPublisher()
    }

    func items<Cell: CollectionViewCell>(cellType: Cell.Type) -> DataSourceSubscriber<Cell.Item> {
        items(dataSource: .make(collectionView: self, cellType: cellType))
    }

    func items<Item: Hashable>(dataSource: CollectionViewDataSource<Item>) -> DataSourceSubscriber<Item> {
        DataSourceSubscriber(
            receiveSubscription: { subscription in subscription.request(.unlimited) },
            receiveValue: { [weak self] state -> Subscribers.Demand in
                guard let self = self else { return .none }
                if self.dataSource == nil { self.dataSource = dataSource }
                self.nextPage = state.nextPage
                self.transition(to: state)
                dataSource.append(state.items, toSection: 0)
                return .unlimited
            },
            receiveCompletion: { _ in }
        )
    }
}
