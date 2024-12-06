//
//  ContactsView.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/5/24.
//

import UIKit

class ListView: UIView {

    // Cell identifier used for table view cell registration and reuse
    static let CellId = "DetailsCell"
    
    // MARK: Properties
    
    // The table view that will display the list of items
    private lazy var tableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: ListView.CellId)
        return tableView
    }()
    
    // The refresh control to allow pull-to-refresh functionality
    private lazy var refreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()
    
    // MARK: Initialization
    
    // Custom initializer
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    // Required initializer for NSCoder (not implemented)
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        setupViews()
    }
    
    // MARK: Private methods
    
    // Set up the table view and layout constraints
    private func setupViews() {
        backgroundColor = .black
        
        // Assign the refresh control to the table view
        tableView.refreshControl = refreshControl
        // Add the table view to the view hierarchy
        addSubview(tableView)
        
        // Activate the layout constraints for the table view
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: Public methods
    
    // Set an action for the refresh control (triggered on pull-to-refresh)
    func setRefreshControlAction(target: Any, action: Selector) {
        refreshControl.addTarget(target, action: action, for: .valueChanged)
    }
    
    // Set the data source for the table view
    func setDataSource(_ dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    // Set the delegate for the table view
    func setDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }
    
    // Reload the table view data and stop the refresh control animation
    func reloadData() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}
