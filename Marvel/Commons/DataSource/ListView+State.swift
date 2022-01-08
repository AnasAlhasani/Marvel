//
//  ListView+State.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

extension UITableView {
    func transition<Value>(to state: ListState<Value>) {
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
        case let .failed(error):
            let errorView = ErrorStateView.instantiateFromNib()
            errorView.display(message: error.localizedDescription)
            backgroundView = errorView
            tableFooterView = UIView(frame: .zero)
        case .paging:
            tableFooterView = LoadingStateView.instantiateFromNib()
        case .populated:
            backgroundView = nil
            tableFooterView = UIView(frame: .zero)
        }
    }
}

extension UICollectionView {
    func transition<Value>(to state: ListState<Value>) {
        switch state {
        case .idle:
            backgroundView = nil
        case .loading, .paging:
            backgroundView = LoadingStateView.instantiateFromNib()
        case .empty:
            backgroundView = EmptyStateView.instantiateFromNib()
        case let .failed(error):
            let errorView = ErrorStateView.instantiateFromNib()
            errorView.display(message: error.localizedDescription)
            backgroundView = errorView
        case .populated:
            backgroundView = nil
        }
    }
}
