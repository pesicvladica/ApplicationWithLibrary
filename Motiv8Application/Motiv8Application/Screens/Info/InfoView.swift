//
//  InfoView.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/5/24.
//

import UIKit
import DeviceInternalsLibrary

class InfoView: UIView {

    // MARK: Properties
    
    // UILabel to display device information details
    private lazy var labelDetails: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 18.0)
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    // MARK: Initialization
    
    // Custom initializer for programmatically creating the view
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    // Required initializer when loading from a storyboard or nib
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        setupViews()
    }
    
    // MARK: Private methods
    
    // Method to setup the view's subviews and layout
    private func setupViews() {
        backgroundColor = .black
        
        // Add the labelDetails to the view
        addSubview(labelDetails)
        
        // Activate Auto Layout constraints to position labelDetails within the view
        NSLayoutConstraint.activate([
            labelDetails.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            labelDetails.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            labelDetails.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelDetails.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ])
    }
    
    // MARK: Public methods
    
    // Method to set the description text in the label based on device information
    func setDescription(_ info: DeviceItem) {
        labelDetails.text = """
                ID: \(info.id)
                
                Title: \(info.title)
                
                OS Version: \(info.osVersion)
                
                Manufacturer: \(info.manufacturer)
                
                Resolution: \(info.screenResolution)
        """
    }
}
