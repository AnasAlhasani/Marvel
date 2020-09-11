//
//  TableDataSource.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

typealias TableCell = CellConfigurable & UITableViewCell
typealias TableDataSourceDelegate = UITableViewDataSource & UITableViewDelegate

final class TableDataSource<Cell: TableCell>: NSObject, TableDataSourceDelegate {
    
    // MARK: - Typealias
    
    typealias DidSelectHandler = (IndexPath) -> Void
    typealias PagingHandler = (Int) -> Void
    typealias CellIndexPathHandler = (Cell, IndexPath) -> Void
    
    // MARK: - Properties
    
    private let tableView: UITableView
    
    var state: State<Cell.Item> = .loading {
        didSet { tableView.display(state) }
    }
    
    // MARK: - Handlers
    
    var didSelectHandler: DidSelectHandler?
    var pagingHandler: PagingHandler?
    var cellIndexPathHandler: CellIndexPathHandler?
    
    // MARK: - Init / Deinit
    
    init(_ tableView: UITableView) {
        self.tableView = tableView
        super.init()
        setup()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(at: indexPath)
        let item = state.items[indexPath.row]
        cell.configure(with: item)
        if case let .paging(_, nextOffset) = state, indexPath.row == state.items.count - 1 {
            pagingHandler?(nextOffset)
        }
        cellIndexPathHandler?(cell, indexPath)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectHandler?(indexPath)
    }
}

// MARK: - Configurations

private extension TableDataSource {
    func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = Color.darkGray.rawValue
    }
}
