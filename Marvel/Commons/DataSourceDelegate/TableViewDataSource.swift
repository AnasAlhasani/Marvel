//
//  TableViewDataSource.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class TableViewDataSource<Cell: CellConfigurable & UITableViewCell>: NSObject, UITableViewDataSource {
    // MARK: Properties

    private let tableView: UITableView
    @Published private(set) var nextPage = 0
    var state: State<Cell.Item> = .loading {
        didSet { tableView.transition(to: state) }
    }

    // MARK: Init / Deinit

    init(_ tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
    }

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        state.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(at: indexPath)
        let item = state.items[indexPath.row]
        cell.configure(with: item)
        if case let .paging(_, nextPage) = state, indexPath.row == state.items.count - 1 {
            self.nextPage = nextPage
        }
        return cell
    }
}
