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
        backgroundView = state.backgroundView
        tableFooterView = state.footerView
    }
}

extension UICollectionView {
    func transition<Value>(to state: ListState<Value>) {
        backgroundView = state.backgroundView
    }
}

private extension ListState {
    var backgroundView: UIView? {
        switch self {
        case let .empty(message):
            return ListStateView(.empty(message))

        case let .failed(error):
            return ListStateView(.failed(error))

        case .loading, .paging:
            return ListStateView(.loading)

        case .idle, .populated:
            return nil
        }
    }

    var footerView: UIView {
        switch self {
        case .paging:
            return ListStateView(.loading)

        default:
            return UIView(frame: .zero)
        }
    }
}
