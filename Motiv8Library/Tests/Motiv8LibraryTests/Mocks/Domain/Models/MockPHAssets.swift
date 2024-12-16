//
//  MockPHAssets.swift
//  
//
//  Created by Vladica Pesic on 12/13/24.
//

import Foundation
import Photos

class MockPHAssets: PHAsset {
    
    override var localIdentifier: String {
        return mockLocalIdentifier
    }
    
    override var description: String {
        return mockDescription
    }
    
    override var creationDate: Date? {
        return mockCreationDate
    }
    
    override var pixelWidth: Int {
        return mockPixelWidth
    }
    
    override var pixelHeight: Int {
        return mockPixelHeight
    }
    
    override var duration: Double {
        return mockDuration
    }
    
    private var mockLocalIdentifier: String
    private var mockDescription: String
    private var mockCreationDate: Date?
    private var mockPixelWidth: Int
    private var mockPixelHeight: Int
    private var mockDuration: Double
    
    init(index: Int) {
        self.mockLocalIdentifier = "\(index)"
        self.mockDescription = "Description \(index)"
        self.mockCreationDate = nil
        self.mockPixelWidth = 3200 + index
        self.mockPixelHeight = 2300 + index
        self.mockDuration = 30.0 + Double(index)
        super.init()
    }
}
