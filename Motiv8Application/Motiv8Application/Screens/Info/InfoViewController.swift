//
//  InfoViewController.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/5/24.
//

import UIKit
import Motiv8Library

class InfoViewController: UIViewController {

    // MARK: Properties
    
    // ViewModel to handle the fetching of device information
    private var viewModel: ItemViewModelProtocol
    
    // Controller view to display the UI
    private lazy var controllerView: InfoView = {
        let view = InfoView()
        return view
    }()
    
    // MARK: Initialization
    
    // Custom initializer that accepts a viewModel conforming to ItemViewModelProtocol
    init(_ viewModel: ItemViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    
    // Required initializer for NSCoder (not implemented)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View lifecycle
    
    // Load the custom view (controllerView) as the view for the controller
    override func loadView() {
        view = controllerView
    }
    
    // Called after the view has been loaded, fetch device information from ViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel.fetchItem()
    }
    
    // MARK: Private methods
    
    // Setup the bindings between the ViewModel and the view
    private func setupBindings() {
        // The ViewModel will call this closure when the item has been fetched
        viewModel.onItemFetched = { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                // Handle the fetched result
                switch result {
                case .success(let deviceInfo):
                    if let info = deviceInfo as? DeviceItem {
                        self.controllerView.setDescription(info)
                    }
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
}
