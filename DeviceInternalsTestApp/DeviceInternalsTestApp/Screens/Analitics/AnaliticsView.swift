//
//  AnaliticsView.swift
//  DeviceInternalsTestApp
//
//  Created by Vladica Pesic on 12/6/24.
//

import UIKit

class AnaliticsView: UIView {

    // MARK: Properties
    
    // UILabel to display information
    private lazy var labelTitle: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 12.0)
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    // UILabel to display information
    private lazy var labelInfo: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 18.0)
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    // Lazy initialization of the stack view for content with vertical axis and spacing
    private lazy var stackViewContent: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()
    
    private lazy var spinner: SpinnerView = {
        let spinnerView = SpinnerView()
        return spinnerView
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
        
        // Add label title
        addSubview(labelTitle)
        // Add label info for presenting results
        addSubview(labelInfo)
        // Add content stack view
        addSubview(stackViewContent)
        
        // Activate Auto Layout constraints to position labelDetails within the view
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            labelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            labelTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            labelInfo.topAnchor.constraint(equalTo: labelTitle.topAnchor, constant: 50),
            labelInfo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            labelInfo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackViewContent.topAnchor.constraint(equalTo: labelInfo.bottomAnchor, constant: 50),
            stackViewContent.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackViewContent.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackViewContent.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
    }
    
    // MARK: Public methods
    
    // Method to set the title of the label
    func setTitle(_ title: String) {
        labelTitle.text = title
    }
    
    // Method for displaying result
    func setInfo(_ info: String) {
        labelInfo.text = info
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
    
    func showSpinner() {
        spinner.show(in: self)
    }
    
    func hideSpinner() {
        spinner.hide()
    }
}
