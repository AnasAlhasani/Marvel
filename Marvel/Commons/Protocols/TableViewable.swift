//
//  TableViewable.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

protocol TableViewable {
    func display<Value>(_ state: State<Value>)
}

extension UITableView: TableViewable {
    func display<Value>(_ state: State<Value>) {
        switch state {
        case .idle:
            tableFooterView = UIView(frame: .zero)
            backgroundView = nil
        case .loading:
            backgroundView = LoadingStateView.instantiateFromNib()
            tableFooterView = UIView(frame: .zero)
        case .empty:
            backgroundView = EmptyStateView.instantiateFromNib()
            tableFooterView = UIView(frame: .zero)
        case let .error(error):
            let errorView = ErrorStateView.instantiateFromNib()
            errorView.display(message: error.localizedDescription)
            backgroundView = errorView
            tableFooterView = UIView(frame: .zero)
        case .paging:
            tableFooterView = LoadingStateView.instantiateFromNib()
        case let .populated(items):
            if items.isEmpty {
                backgroundView = EmptyStateView.instantiateFromNib()
            } else {
                backgroundView = nil
            }
            tableFooterView = UIView(frame: .zero)
        }
        reloadData()
    }
}

extension UICollectionView: TableViewable {
    func display<Value>(_ state: State<Value>) {
        switch state {
        case .idle:
            backgroundView = nil
        case .loading, .paging:
            backgroundView = LoadingStateView.instantiateFromNib()
        case .empty:
            backgroundView = EmptyStateView.instantiateFromNib()
        case let .error(error):
            let errorView = ErrorStateView.instantiateFromNib()
            errorView.display(message: error.localizedDescription)
            backgroundView = errorView
        case let .populated(items):
            if items.isEmpty {
                backgroundView = EmptyStateView.instantiateFromNib()
            } else {
                backgroundView = nil
            }
        }
        reloadData()
    }
}
