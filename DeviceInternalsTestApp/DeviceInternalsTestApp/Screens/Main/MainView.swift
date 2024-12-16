//
//  MainView.swift
//  DeviceInternalsTestApp
//
//  Created by Vladica Pesic on 12/5/24.
//

import UIKit

class MainView: UIView {
    
    // MARK: Properties
    
    // Lazy initialization of the title label with text alignment, font, color, and number of lines
    private lazy var labelTitle: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 16.0)
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    // Lazy initialization of the stack view for content with vertical axis and spacing
    private lazy var stackViewContent: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 50
        return stackView
    }()
    
    // MARK: Initialization
    
    // Custom initializer that calls the superclass initializer with a frame of zero and sets up the views
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    // Required initializer for loading from storyboard or XIB file
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        setupViews()
    }
    
    // MARK: Private methods
    
    // Method to set up the layout and add subviews
    private func setupViews() {
        backgroundColor = .black
        
        // Add the title label and stack view to the main view
        addSubview(labelTitle)
        addSubview(stackViewContent)
        
        // Activate AutoLayout constraints to position the elements
        NSLayoutConstraint.activate([
            labelTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            labelTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            labelTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50),
            stackViewContent.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackViewContent.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackViewContent.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 100),
            stackViewContent.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    // MARK: Public methods
    
    // Method to set the title of the label
    func setTitle(_ title: String) {
        labelTitle.text = title
    }
    
    // Method to add a button to the stack view with specific properties
    func addButton(title: String, target: Any, action: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(target, action: action, for: .primaryActionTriggered)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        stackViewContent.addArrangedSubview(button)
    }
}

