//
//  SearchViewController.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var tableView: UITableView!

    // MARK: - Properties

    private lazy var dataSource = TableDataSource<SearchCell>(tableView)
    // swiftlint:disable implicitly_unwrapped_optional
    var viewModel: CharactersViewModel!

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.placeholder = L10n.Search.title
        return searchController
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        viewModel.state.bind { [weak self] in self?.dataSource.state = $0 }
        dataSource.pagingHandler = { [weak self] in self?.viewModel.loadCharacters(at: $0) }
        dataSource.didSelectHandler = { [weak self] in self?.viewModel.didSelectRow(at: $0) }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
    }
}

// MARK: - Configurations

private extension SearchViewController {
    func setUpNavigationItem() {
        navigationItem.hidesBackButton = true
        navigationItem.titleView = searchController.searchBar
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.loadCharacters(with: searchBar.text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didTapCancelSearch()
    }
}

// MARK: - UISearchControllerDelegate

extension SearchViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async { searchController.searchBar.becomeFirstResponder() }
    }
}
