//
//  ParallelogramView.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class ErrorStateView: UIView {
    // MARK: Outlets

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
}

// MARK: - Presentation

extension ErrorStateView {
    func display(message: String) {
        titleLabel.text = L10n.State.error
        descriptionLabel.text = message
    }
}
