//
//  AnaliticsViewController.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/6/24.
//

import UIKit

// Enum representing different analityc option to choose from in the UI
enum AnalyticsOption: String, CaseIterable {
    case contacts = "Contacts"  // Option to view contacts analitics
    case images = "Images"      // Option to view images analitics
    case videos = "Videos"      // Option to view videos analitics
}

class AnaliticsViewController: UIViewController {

    // MARK: Properties
    
    // ViewModel to handle analitics
    private var viewModel: AnaliticsViewModel
    
    // Controller view to display the UI
    private lazy var controllerView: AnaliticsView = {
        let view = AnaliticsView()
        return view
    }()
    
    // MARK: Initialization
    
    // Custom initializer that accepts AnaliticsViewModel
    init(_ viewModel: AnaliticsViewModel) {
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
        controllerView.setTitle("Select Option to see analitics, depending of number of items on your device fetching results could take longer time.")

        // Add buttons for each option in the Option enum to the controller view
        for option in AnalyticsOption.allCases {
            controllerView.addButton(title: option.rawValue, target: self, action: #selector(buttonPressed))
        }
    }
    
    // MARK: Private methods
    
    // Setup the bindings between the ViewModel and the view
    private func setupBindings() {
        viewModel.onResultsFetched = { [weak self] data, error in
            DispatchQueue.main.async {
                self?.controllerView.hideSpinner()
                
                if let result = data {
                    self?.controllerView.setInfo(result)
                }
                else {
                    self?.showError(error: error)
                }
            }
        }
    }
    
    // Action method that is called when a button is pressed
    @objc private func buttonPressed(_ sender: UIButton) {
        // Get the title of the button that was pressed
        let title = sender.title(for: .normal) ?? ""
        
        // Create an Option from the button title
        let option = AnalyticsOption(rawValue: title)
        
        // Handle the different options by pushing the corresponding view controller
        switch option {
        case .contacts:
            controllerView.showSpinner()
            viewModel.calculateForContacts()
        case .images:
            controllerView.showSpinner()
            viewModel.calculateForImages()
        case .videos:
            controllerView.showSpinner()
            viewModel.calculateForVideos()
        case nil:
            debugPrint("Unhandled button event captured.")
        }
    }
    
    // Show error message (for now, just logs it)
    private func showError(error: Error?) {
        debugPrint(error?.localizedDescription ?? "Undefined error")
    }
}
