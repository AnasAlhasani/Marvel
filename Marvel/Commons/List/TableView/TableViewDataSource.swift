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
typealias TableViewDataSource<Item: Hashable> = UITableViewDiffableDataSource<ListSection, Item>

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
