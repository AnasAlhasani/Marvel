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
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet { tableView.register(ComicTableCell.self) }
    }
    @IBOutlet private weak var headerView: CharecterDetailHeaderView!
    
    // MARK: - Properties
    
    private lazy var dataSource = TableDataSource<ComicTableCell>(tableView)
    private lazy var useCase = APIComicUseCase()
    private var viewModel: CharacterDetailViewModel!
    var viewItem: CharacterViewItem?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = viewItem else { return }
        title = item.name
        headerView.configure(with: item)
        viewModel = CharacterDetailViewModel(useCase: useCase, item: item)
        viewModel.loadComics()
        viewModel.state.bind { [weak self] in self?.dataSource.state = $0 }
        dataSource.cellIndexPathHandler = { [weak self] cell, indexPath in
            self?.didConfigure(cell, at: indexPath)
        }
    }
}

// MARK: - Configurations 

private extension CharacterDetailViewController {
    func didConfigure<Cell: TableCell>(_ cell: Cell, at indexPath: IndexPath) {
        guard let cell = cell as? ComicTableCell else { return }
        let item = viewModel.state.value.items[indexPath.row]
        cell.configure(with: item)
    }
}
