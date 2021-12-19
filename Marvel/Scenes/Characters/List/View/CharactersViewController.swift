//
//  CharactersViewController.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class CharactersViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var tableView: UITableView!

    // MARK: - Properties

    private lazy var dataSource = TableViewDataSource<CharactersCell>(tableView)
    // swiftlint:disable implicitly_unwrapped_optional
    var viewModel: CharactersViewModel!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadCharacters()
        viewModel.state.bind { [weak self] in self?.dataSource.state = $0 }
        dataSource.pagingHandler = { [weak self] in self?.viewModel.loadCharacters(at: $0) }
        dataSource.didSelectHandler = { [weak self] in self?.viewModel.didSelectRow(at: $0) }
    }
}

// MARK: - Interactions

private extension CharactersViewController {
    @IBAction
    func didTapSearchButtonItem(_ sender: UIBarButtonItem) {
        viewModel.didTapSearch()
    }
}
