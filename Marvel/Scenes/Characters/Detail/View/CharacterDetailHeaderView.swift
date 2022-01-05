//
//  CharacterDetailHeaderView.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class CharacterDetailHeaderView: UIView {
    // MARK: Outlets

    @IBOutlet private var characterImageView: UIImageView!
    @IBOutlet private var nameTitleLabel: UILabel!
    @IBOutlet private var nameValueLabel: UILabel!
    @IBOutlet private var descriptionTitleLabel: UILabel!
    @IBOutlet private var descriptionValueLabel: UILabel!
}

// MARK: Configurations

extension CharacterDetailHeaderView {
    func configure(with item: CharacterItem) {
        characterImageView.download(image: item.imageURL)
        nameTitleLabel.text = item.nameTitle
        nameValueLabel.text = item.name
        descriptionTitleLabel.text = item.descriptionTitle
        descriptionValueLabel.text = item.description
    }
}
