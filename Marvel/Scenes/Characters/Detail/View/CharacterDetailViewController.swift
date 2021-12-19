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

    private lazy var dataSource = TableDataSource<MediaTableCell>(tableView)
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
        dataSource.cellIndexPathHandler = { [weak self] cell, indexPath in
            self?.didConfigure(cell, at: indexPath)
        }
    }

    func didConfigure<Cell: TableCell>(_ cell: Cell, at indexPath: IndexPath) {
        guard let cell = cell as? MediaTableCell else { return }
        let item = viewModel.state.value.items[indexPath.row]
        cell.configure(with: item)
    }
}
