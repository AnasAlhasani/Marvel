//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import UIKit

// swiftlint:disable implicitly_unwrapped_optional

final class CharacterDetailViewController: UIViewController {
    // MARK: Outlets

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var headerView: CharacterDetailHeaderView!

    // MARK: Properties

    private lazy var dataSource = TableViewDataSource<MediaTableCell>(tableView)
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private var cancellable = Set<AnyCancellable>()
    var viewModel: CharacterDetailViewModel!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

// MARK: Bindings

private extension CharacterDetailViewController {
    func bindViewModel() {
        let input = CharacterDetailViewModel.Input(
            viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        dataSource.cellConfigurator = { [dataSource] (cell: MediaTableCell, indexPath) in
            let item = dataSource.state.items[indexPath.row]
            cell.configure(with: item)
        }

        output.character
            .sink { [weak self] in
                self?.title = $0.name
                self?.headerView.configure(with: $0)
            }
            .store(in: &cancellable)

        output.state
            .sink { [weak self] in self?.dataSource.state = $0 }
            .store(in: &cancellable)

        viewDidLoadSubject.send()
    }
}
