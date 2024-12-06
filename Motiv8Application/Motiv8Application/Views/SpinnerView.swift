//
//  SpinnerView.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/6/24.
//

import UIKit

class SpinnerView: UIView {

    // Lazy initialization of activity indicator to show while loading data
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // Setup the spinner and blocking view
    private func setupView() {
        // Set the background to semi-transparent to block interactions
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Add the spinner to the view and center it
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // Show the spinner in a given view
    func show(in view: UIView) {
        activityIndicator.startAnimating()
        
        view.addSubview(self)
        self.frame = view.bounds
        
        // Disable user interaction with underlying views
        self.isUserInteractionEnabled = true
    }
    
    // Remove the spinner from the view
    func hide() {
        activityIndicator.stopAnimating()
        self.removeFromSuperview()
    }
}
