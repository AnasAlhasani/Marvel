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
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private lazy var dataSource = TableDataSource<CharactersCell>(tableView)
    private lazy var useCase = APICharacterUseCase()
    private lazy var viewModel = CharactersViewModel(useCase: useCase)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.state.bind { [weak self] in self?.dataSource.state = $0 }
        viewModel.loadCharecters()
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
 
}

// MARK: - Interactions

private extension CharactersViewController {
    
    @IBAction func didTapSearchButtonItem(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "\(SearchViewController.self)")
        navigationController?.pushViewController(controller, animated: true)
    }
}
