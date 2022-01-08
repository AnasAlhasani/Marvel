//
//  TableViewDataSource.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import CombineSchedulers
import UIKit

typealias TableViewCell = UITableViewCell & CellConfigurable
typealias TableViewDataSource<Item: Hashable> = UITableViewDiffableDataSource<AnyHashable, Item>

extension UITableViewDiffableDataSource {
    static func make<Cell: TableViewCell>(
        tableView: UITableView,
        cellType: Cell.Type
    ) -> UITableViewDiffableDataSource where Cell.Item == ItemIdentifierType {
        UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell: Cell = tableView.dequeueReusableCell(at: indexPath)
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

extension UITableView {
    typealias DataSourceSubscriber<Item: Hashable> = AnySubscriber<ListState<Item>, Never>

    private var nextPage: Int? {
        get { value(for: &nextPageKey) }
        set { setValue(newValue, for: &nextPageKey) }
    }

    var nextPagePublisher: AnyPublisher<Int, Never> {
        willDisplayCellPublisher
            .filter { [unowned self] in
                nextPage != .none && $1.row == numberOfRows(inSection: 0) - 1
            }
            .compactMap { [unowned self] _ in nextPage }
            .eraseToAnyPublisher()
    }

    func items<Cell: TableViewCell>(cellType: Cell.Type) -> DataSourceSubscriber<Cell.Item> {
        items(dataSource: .make(tableView: self, cellType: cellType))
    }

    func items<Item: Hashable>(dataSource: TableViewDataSource<Item>) -> DataSourceSubscriber<Item> {
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
