//
//  MainViewController.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/4/24.
//

import UIKit
import Motiv8Library

// Enum representing different options to choose from in the UI
enum Option: String, CaseIterable {
    case contacts = "Contacts"  // Option to view contacts
    case images = "Images"      // Option to view images
    case videos = "Videos"      // Option to view videos
    case info = "Device Info"   // Option to view device information
}

class MainViewController: UIViewController {

    // MARK: Properties
    
    // Instance of the Motiv8Library that provides fetchers for contacts, images, videos, and device info
    let motiv8Lib = Motiv8Library()
    
    // Lazy initialization of the main view controller's view
    private lazy var controllerView: MainView = {
        let view = MainView()
        return view
    }()
        
    // MARK: View lifecycle
    
    // Override loadView to assign the custom controller view as the main view
    override func loadView() {
        view = controllerView
    }
    
    // Override viewDidLoad to set up the view after loading
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title on the main view
        controllerView.setTitle("Choose one of the provided options to inspect.")
        
        // Add buttons for each option in the Option enum to the controller view
        for option in Option.allCases {
            controllerView.addButton(title: option.rawValue, target: self, action: #selector(buttonPressed))
        }
    }
    
    // MARK: Private methods

    // Action method that is called when a button is pressed
    @objc private func buttonPressed(_ sender: UIButton) {
        // Get the title of the button that was pressed
        let title = sender.title(for: .normal) ?? ""
        
        // Create an Option from the button title
        let option = Option(rawValue: title)
        
        // Handle the different options by pushing the corresponding view controller
        switch option {
        case .contacts:
            let viewModel = ContactsViewModel(fetcher: motiv8Lib.contactFetcher)
            let vc = ListViewController(viewModel)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        case .images:
            let viewModel = ImagesViewModel(fetcher: motiv8Lib.imageFetcher)
            let vc = ListViewController(viewModel)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        case .videos:
            let viewModel = VideosViewModel(fetcher: motiv8Lib.videoFetcher)
            let vc = ListViewController(viewModel)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        case .info:
            let viewModel = InfoViewModel(fetcher: motiv8Lib.infoFetcher)
            let vc = InfoViewController(viewModel)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        case nil:
            debugPrint("Unhandled button event captured.")
        }
    }
}
