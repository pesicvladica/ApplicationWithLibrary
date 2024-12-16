//
//  MainViewController.swift
//  DeviceInternalsTestApp
//
//  Created by Vladica Pesic on 12/4/24.
//

import UIKit
import DeviceInternalsLibrary

// Enum representing different options to choose from in the UI
enum Option: String, CaseIterable {
    case contacts = "Contacts"  // Option to view contacts
    case images = "Images"      // Option to view images
    case videos = "Videos"      // Option to view videos
    case info = "Device Info"   // Option to view device information
    case analytics = "Analitics"// Option to view analitics
}

class MainViewController: UIViewController {

    // MARK: Properties
    
    // Instance of the DeviceInternalsLibrary that provides fetchers for contacts, images, videos, and device info
    let diLib = DeviceInternalsLibrary.createDefaultLibrary()
    
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
            let viewModel = ContactsViewModel(fetcher: diLib.contactFetcher)
            let vc = ListViewController(viewModel)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        case .images:
            let viewModel = ImagesViewModel(fetcher: diLib.imageFetcher)
            let vc = ListViewController(viewModel)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        case .videos:
            let viewModel = VideosViewModel(fetcher: diLib.videoFetcher)
            let vc = ListViewController(viewModel)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        case .info:
            let viewModel = InfoViewModel(fetcher: diLib.infoFetcher)
            let vc = InfoViewController(viewModel)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        case .analytics:
            let viewModel = AnaliticsViewModel(diLibrary: diLib)
            let vc = AnaliticsViewController(viewModel)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        case nil:
            debugPrint("Unhandled button event captured.")
        }
    }
}

