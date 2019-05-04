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

private enum StateViewName {
    static let loading = "LoadingStateView"
    static let empty = "EmptyStateView"
}

extension UITableView: TableViewable {
    
    func display<Value>(_ state: State<Value>) {
        switch state {
        case .default:
            tableFooterView = UIView(frame: .zero)
            backgroundView = nil
        case .loading:
            backgroundView = UIView.loadView(form: StateViewName.loading)
            tableFooterView = UIView(frame: .zero)
        case .empty:
            backgroundView = UIView.loadView(form: StateViewName.empty)
            tableFooterView = UIView(frame: .zero)
        case let .error(error):
            let errorView = ErrorStateView.instantiateFromNib()
            errorView.display(message: error.localizedDescription)
            backgroundView = errorView
            tableFooterView = UIView(frame: .zero)
        case .paging:
            tableFooterView = UIView.loadView(form: StateViewName.loading)
        case let .populated(items):
            if items.isEmpty {
                backgroundView = UIView.loadView(form: StateViewName.empty)
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
        case .default:
            backgroundView = nil
        case .loading, .paging:
            backgroundView = UIView.loadView(form: StateViewName.loading)
        case .empty:
            backgroundView = UIView.loadView(form: StateViewName.empty)
        case let .error(error):
            let errorView = ErrorStateView.instantiateFromNib()
            errorView.display(message: error.localizedDescription)
            backgroundView = errorView
        case let .populated(items):
            if items.isEmpty {
                backgroundView = UIView.loadView(form: StateViewName.empty)
            } else {
                backgroundView = nil
            }
        }
        reloadData()
    }
}
