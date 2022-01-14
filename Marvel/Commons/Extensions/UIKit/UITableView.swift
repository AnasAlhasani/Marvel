//
//  UITableView.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/2/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import UIKit

// MARK: - Commons

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(at indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Couldn't dequeue cell with identifier: \(identifier)")
        }
        return cell
    }
}

// MARK: - DataSource

extension UITableView {
    typealias DataSourceSubscriber<Item: Hashable> = AnySubscriber<ListState<Item>, Never>

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
                dataSource.append(state.items, toSection: .main)
                return .unlimited
            },
            receiveCompletion: { _ in }
        )
    }
}

// MARK: - Delegate

extension UITableView {
    private enum AssociatedKeys {
        static var nextPage = "nextPageKey"
    }

    private var nextPage: Int? {
        get { value(for: &AssociatedKeys.nextPage) }
        set { setValue(newValue, for: &AssociatedKeys.nextPage) }
    }

    var nextPagePublisher: AnyPublisher<Int, Never> {
        willDisplayCellPublisher
            .filter { [unowned self] in
                nextPage != .none && $1.row == numberOfRows(inSection: 0) - 1
            }
            .compactMap { [unowned self] _ in nextPage }
            .eraseToAnyPublisher()
    }
}
