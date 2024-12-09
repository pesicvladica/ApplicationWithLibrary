//
//  ContactsViewController.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/5/24.
//

import UIKit
import Motiv8Library

class ListViewController: UIViewController {

    // MARK: Properties
        
    // The ViewModel that contains the business logic for the list view
    private var viewModel: ListViewModelProtocol
    
    // The custom view representing the list and its table view
    private lazy var controllerView: ListView = {
        let view = ListView()
        // Set actions for the refresh control and assign the data source and delegate for the table view
        view.setRefreshControlAction(target: self, action: #selector(refreshData))
        view.setDataSource(self)
        view.setDelegate(self)
        return view
    }()
    
    // MARK: Initialization
    
    // Custom initializer that takes a ViewModel
    init(_ viewModel: ListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    
    // Required initializer for NSCoder (not implemented)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View lifecycle
    
    // Override loadView to use the custom controller view
    override func loadView() {
        view = controllerView
    }
    
    // Called after the view is loaded, here we start fetching data
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch the first page of data
        viewModel.fetchNextPage()
    }
    
    // MARK: Private methods

    // Set up bindings between the view model and the view
    private func setupBindings() {
        viewModel.onDataFetched = { [weak self] error in
            Task {
                await MainActor.run {
                    if let error = error {
                        // If an error occurs, display it
                        self?.showError(error: error)
                    }
                    else {
                        // If data is successfully fetched, reload the table view
                        self?.controllerView.reloadData()
                    }
                }
            }
        }
    }
    
    // Show error message (for now, just logs it)
    private func showError(error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    // Action triggered by pull-to-refresh gesture
    @objc private func refreshData() {
        viewModel.resetAndFetch()
    }
}

// Conforms to UITableViewDataSource to manage data for the table view
extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListView.CellId, for: indexPath) as? DetailsTableViewCell else {
            preconditionFailure("Only details table view cell is allowed")
        }
        
        // Get the data for the current row and configure the cell accordingly
        let data = viewModel.listItems[indexPath.row]
        if let contactData = data as? ContactItem {
            // Set data for contact item
            cell.setContactData(contactData)
        }
        else if let imageData = data as? ImageItem {
            // Set data for image item
            cell.setImageData(imageData)
        }
        else if let videoData = data as? VideoItem {
            // Set data for video item
            cell.setVideoData(videoData)
        }
        else {
            // If no matching data, clear the cell
            cell.clearData()
        }
        
        return cell
    }
}

// Conforms to UITableViewDelegate to handle row selection and other delegate methods
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.listItems.count - 1 {
            viewModel.fetchNextPage()
        }
    }
}
