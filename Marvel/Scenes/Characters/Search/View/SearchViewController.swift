//
//  SearchViewController.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import UIKit

// swiftlint:disable implicitly_unwrapped_optional

final class SearchViewController: UIViewController {
    // MARK: Outlets

    @IBOutlet private var tableView: UITableView!

    // MARK: Properties

    private lazy var dataSource = TableViewDataSource<SearchCell>(tableView)
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

    private let nextPageSubject = PassthroughSubject<Int, Never>()
    private let didSelectRowSubject = PassthroughSubject<CharacterItem, Never>()
    private let searchSubject = PassthroughSubject<String, Never>()
    private let didDismissSearchSubject = PassthroughSubject<Void, Never>()
    private var cancellable = Set<AnyCancellable>()

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
            viewDidLoad: .passthroughSubject,
            nextPage: nextPageSubject.eraseToAnyPublisher(),
            didSelectRow: didSelectRowSubject.eraseToAnyPublisher(),
            search: searchSubject.eraseToAnyPublisher(),
            didTapSearch: .passthroughSubject,
            didDismissSearch: didDismissSearchSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        dataSource.pagingHandler = { [weak self] in
            self?.nextPageSubject.send($0)
        }

        dataSource.didSelectHandler = { [weak self, dataSource] in
            self?.didSelectRowSubject.send(dataSource.state.items[$0.row])
        }

        output
            .sink { [weak self] in self?.dataSource.state = $0 }
            .store(in: &cancellable)
    }
}

// MARK: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchSubject.send(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        didDismissSearchSubject.send()
    }
}

// MARK: UISearchControllerDelegate

extension SearchViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async { searchController.searchBar.becomeFirstResponder() }
    }
}
