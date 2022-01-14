//
//  ListStateView.swift
//  Marvel
//
//  Created by Anas Alhasani on 12/01/2022.
//  Copyright © 2022 Anas Alhasani. All rights reserved.
//

import UIKit

final class ListStateView: UIView {
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private let state: State

    init(_ state: State) {
        self.state = state
        super.init(frame: .listState)
        setupViews()
    }

    required init?(coder: NSCoder) { nil }

    private func setupViews() {
        loadFromNib()
        messageLabel.text = state.message
        activityIndicator.isHidden = !state.isLoading
    }
}

extension ListStateView {
    enum State {
        case loading
        case empty(String)
        case failed(Error)

        var isLoading: Bool {
            if case .loading = self {
                return true
            } else {
                return false
            }
        }

        var message: String? {
            switch self {
            case .loading:
                return nil

            case let .empty(message):
                return message

            case let .failed(error):
                return error.localizedDescription
            }
        }
    }
}

private extension CGRect {
    static let width = UIScreen.main.bounds.width
    static let height: CGFloat = 100
    static let listState = CGRect(x: 0, y: 0, width: width, height: height)
}
