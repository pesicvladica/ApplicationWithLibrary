//
//  DetailsTableViewCell.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/5/24.
//

import UIKit
import DeviceInternalsLibrary

class DetailsTableViewCell: UITableViewCell {

    // MARK: Private properties
    
    // Lazy initialization of the title label with text color, font, and layout properties
    private lazy var labelTitle: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 14.0)
        return textLabel
    }()
    
    // Lazy initialization of the additional label with alignment, text color, and font size
    private lazy var labelAdditional: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .right
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 8.0)
        return textLabel
    }()
    
    // Lazy initialization of the subtitle label with text color and font size
    private lazy var labelSubtitle: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 12.0)
        return textLabel
    }()
    
    // Lazy initialization of the description label with text color and font size
    private lazy var labelDescription: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 11.0)
        return textLabel
    }()
    
    // MARK: Initialization
    
    // Required initializer for loading from storyboard or XIB file
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // Custom initializer for initializing with a style and reuse identifier
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    // MARK: Private methods
    
    // Method to set up the layout and add subviews
    private func setupView() {
        backgroundColor = .black
        
        // Add the labels to the content view of the cell
        contentView.addSubview(labelTitle)
        contentView.addSubview(labelAdditional)
        contentView.addSubview(labelSubtitle)
        contentView.addSubview(labelDescription)
        
        // Activate AutoLayout constraints to position the labels
        NSLayoutConstraint.activate([
            labelAdditional.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            labelAdditional.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            labelTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            labelTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            labelTitle.trailingAnchor.constraint(equalTo: labelAdditional.leadingAnchor, constant: -8),
            labelSubtitle.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelSubtitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            labelSubtitle.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 8),
            labelDescription.leadingAnchor.constraint(equalTo: labelSubtitle.leadingAnchor),
            labelDescription.trailingAnchor.constraint(equalTo: labelSubtitle.trailingAnchor),
            labelDescription.topAnchor.constraint(equalTo: labelSubtitle.bottomAnchor, constant: 8),
            labelDescription.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    // MARK: Public methods

    // Method to populate the cell with contact data
    func setContactData(_ data: ContactItem) {
        labelTitle.text = data.title
        labelAdditional.text = ""
        labelSubtitle.text = "[ " + data.phoneNumbers.joined(separator: " ] [ ") + " ]"
        labelDescription.text = data.emails.joined(separator: ", ")
    }
    
    // Method to populate the cell with image data
    func setImageData(_ data: ImageItem) {
        labelTitle.text = "Image Size { Width: \(data.dimension.width) , Height: \(data.dimension.height) }"
        labelAdditional.text = ""
        labelSubtitle.text = "Created at: " + data.dateCreated.formatted()
        labelDescription.text = String(format: "Filesize: %.2f MB", Double(data.byteFileSize) / (1024.0 * 1024.0))
    }
    
    // Method to populate the cell with video data
    func setVideoData(_ data: VideoItem) {
        labelTitle.text = String(format: "Video duration is: %.2f s", data.duration)
        labelAdditional.text = ""
        labelSubtitle.text = "Created at: " + data.dateCreated.formatted()
        labelDescription.text = String(format: "Filesize: %.2f MB", Double(data.byteFileSize) / (1024.0 * 1024.0))
    }
    
    // Method to clear the data in the cell (reset the labels)
    func clearData() {
        labelTitle.text = ""
        labelAdditional.text = ""
        labelSubtitle.text = ""
        labelDescription.text = ""
    }
}
