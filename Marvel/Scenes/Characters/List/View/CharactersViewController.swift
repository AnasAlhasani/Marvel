//
//  CharactersViewController.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import UIKit

// swiftlint:disable implicitly_unwrapped_optional

final class CharactersViewController: UIViewController {
    // MARK: Outlets

    @IBOutlet private var tableView: UITableView!

    // MARK: Properties

    private lazy var dataSource = TableViewDataSource<CharactersCell>(tableView)

    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let nextPageSubject = PassthroughSubject<Int, Never>()
    private let didSelectRowSubject = PassthroughSubject<CharacterItem, Never>()
    private let didTapSearchSubject = PassthroughSubject<Void, Never>()
    private var cancellable = Set<AnyCancellable>()

    var viewModel: CharactersViewModel!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

// MARK: Binding

private extension CharactersViewController {
    func bindViewModel() {
        let input = CharactersViewModel.Input(
            viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher(),
            nextPage: nextPageSubject.eraseToAnyPublisher(),
            didSelectRow: didSelectRowSubject.eraseToAnyPublisher(),
            search: .passthroughSubject,
            didTapSearch: didTapSearchSubject.eraseToAnyPublisher(),
            didDismissSearch: .passthroughSubject
        )

        viewModel.transform(input: input)
            .sink { [weak self] in self?.dataSource.state = $0 }
            .store(in: &cancellable)

        viewDidLoadSubject.send()

        dataSource.pagingHandler = { [weak self] in
            self?.nextPageSubject.send($0)
        }

        dataSource.didSelectHandler = { [weak self, dataSource] in
            self?.didSelectRowSubject.send(dataSource.state.items[$0.row])
        }
    }
}

// MARK: Interactions

private extension CharactersViewController {
    @IBAction
    func didTapSearchButtonItem(_ sender: UIBarButtonItem) {
        didTapSearchSubject.send()
    }
}
