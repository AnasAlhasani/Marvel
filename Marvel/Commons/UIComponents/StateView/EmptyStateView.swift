//
//  EmptyStateView.swift
//  Marvel
//
//  Created by Anas Alhasani on 13/05/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import UIKit

final class EmptyStateView: UIView {
    // MARK: Outlets

    @IBOutlet private var descriptionLabel: UILabel! {
        didSet { descriptionLabel.text = L10n.State.empty }
    }
}
