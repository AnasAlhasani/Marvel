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
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private lazy var dataSource = TableDataSource<SearchCell>(tableView)
    private lazy var useCase = APICharacterUseCase()
    private lazy var viewModel = CharactersViewModel(useCase: useCase)
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        viewModel.state.bind { [weak self] in self?.dataSource.state = $0 }
        dataSource.pagingHandler = { [weak self] in self?.viewModel.loadCharecters(at: $0) }
        dataSource.didSelectHandler = { [weak self] indexPath in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let identifier = "\(CharacterDetailViewController.self)"
            let controller = storyboard.instantiateViewController(withIdentifier: identifier)
            if let details = controller as? CharacterDetailViewController {
                details.viewItem = self?.viewModel.state.value.items[indexPath.row]
            }
            self?.navigationController?.pushViewController(controller, animated: true)
        }
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
        viewModel.loadCharecters(with: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UISearchControllerDelegate

extension SearchViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async { searchController.searchBar.becomeFirstResponder() }
    }
}
