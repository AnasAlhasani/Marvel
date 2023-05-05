//
//  SearchViewController.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import CombineCocoa
import UIKit

final class SearchViewController: UIViewController {
    // MARK: Outlets

    @IBOutlet private var tableView: UITableView!

    // MARK: Properties

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.placeholder = L10n.Search.title
        return searchController
    }()

    private let cancelBag = CancelBag()
    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModel: CharactersViewModel!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
    }
}

// MARK: SetUp & Bindings

private extension SearchViewController {
    func setUpNavigationItem() {
        navigationItem.hidesBackButton = true
        navigationItem.titleView = searchController.searchBar
    }

    func bindViewModel() {
        let input = CharactersViewModel.Input(
            viewDidLoad: .empty,
            nextPage: tableView.nextPagePublisher,
            didSelectRow: tableView.didSelectRowPublisher,
            search: searchController.searchBar.textDidChangePublisher,
            didTapSearch: .empty,
            didDismissSearch: searchController.searchBar.cancelButtonClickedPublisher
        )

        viewModel.transform(input: input)
            .bind(to: tableView.items(cellType: SearchCell.self))
            .store(in: cancelBag)
    }
}

// MARK: UISearchControllerDelegate

extension SearchViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async { searchController.searchBar.becomeFirstResponder() }
    }
}
