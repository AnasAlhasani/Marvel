//
//  CharacterDetailsViewController.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import UIKit

final class CharacterDetailsViewController: UIViewController {
    // MARK: Outlets

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var headerView: CharacterDetailsHeaderView!

    // MARK: Properties

    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private var cancellable = Set<AnyCancellable>()

    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModel: CharacterDetailsViewModel!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

// MARK: Bindings

private extension CharacterDetailsViewController {
    func bindViewModel() {
        let input = CharacterDetailsViewModel.Input(
            viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.character
            .sink { [weak self] in
                self?.title = $0.name
                self?.headerView.configure(with: $0)
            }
            .store(in: &cancellable)

        output.state
            .bind(to: tableView.items(cellType: MediaTableCell.self))
            .store(in: &cancellable)

        viewDidLoadSubject.send()
    }
}
