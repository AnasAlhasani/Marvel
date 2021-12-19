//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class CharacterDetailViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var tableView: UITableView! {
        didSet { tableView.register(MediaTableCell.self) }
    }

    @IBOutlet private var headerView: CharacterDetailHeaderView!

    // MARK: - Properties

    private lazy var dataSource = TableViewDataSource<MediaTableCell>(tableView)
    // swiftlint:disable implicitly_unwrapped_optional
    var viewModel: CharacterDetailViewModel!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        handleViewModel()
        handleDataSource()
    }
}

// MARK: - Configurations

private extension CharacterDetailViewController {
    func handleViewModel() {
        viewModel.loadItems()
        viewModel.state.bind { [weak self] in self?.dataSource.state = $0 }
        viewModel.character.bind { [weak self] in
            self?.title = $0.name
            self?.headerView.configure(with: $0)
        }
    }

    func handleDataSource() {
        dataSource.cellConfigurator = { [weak self] (cell: MediaTableCell, indexPath) in
            guard let self = self else { return }
            let item = self.viewModel.state.value.items[indexPath.row]
            cell.configure(with: item)
        }
    }
}
