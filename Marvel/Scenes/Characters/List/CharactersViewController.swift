//
//  CharactersViewController.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import CombineCocoa
import UIKit

final class CharactersViewController: UIViewController {
    // MARK: Outlets

    @IBOutlet private var searchBarButtonItem: UIBarButtonItem!
    @IBOutlet private var tableView: UITableView!

    // MARK: Properties

    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let cancelBag = CancelBag()

    // swiftlint:disable:next implicitly_unwrapped_optional
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
            nextPage: tableView.nextPagePublisher,
            didSelectRow: tableView.didSelectRowPublisher,
            search: .empty,
            didTapSearch: searchBarButtonItem.tapPublisher,
            didDismissSearch: .empty
        )

        let output = viewModel.transform(input: input)

        output
            .bind(to: tableView.items(cellType: CharactersCell.self))
            .store(in: cancelBag)

        viewDidLoadSubject.send()
    }
}
