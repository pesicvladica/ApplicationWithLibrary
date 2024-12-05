//
//  MockMediaItems.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import Photos
@testable import Motiv8Library

class MockPHAsset: PHAsset {
    static var assetFetchResult = MockPHAssetFetchResult()
    
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
    
    init(localIdentifier: String, 
         description: String,
         creationDate: Date?,
         pixelWidth: Int,
         pixelHeight: Int,
         duration: Double) {
        self.mockLocalIdentifier = localIdentifier
        self.mockDescription = description
        self.mockCreationDate = creationDate
        self.mockPixelWidth = pixelWidth
        self.mockPixelHeight = pixelHeight
        self.mockDuration = duration
        super.init()
    }
    
    override class func fetchAssets(with mediaType: PHAssetMediaType, options: PHFetchOptions?) -> PHFetchResult<PHAsset> {
        return MockPHAsset.assetFetchResult
    }
}

class MockPHAssetFetchResult: PHFetchResult<PHAsset> {
    var assets: [PHAsset]
    
    override init() {
        self.assets = []
        super.init()
    }
    
    override func enumerateObjects(_ block: @escaping (PHAsset, Int, UnsafeMutablePointer<ObjCBool>) -> Void) {
        for (index, asset) in assets.enumerated() {
            block(asset, index, UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1))
        }
    }
    
    override var count: Int {
        return assets.count
    }
}

class MockPHAssetResource: PHAssetResource {
    override init() {
        super.init()
    }
    
    override class func assetResources(for asset: PHAsset) -> [PHAssetResource] {
        let mockResource = MockPHAssetResource()
        mockResource.setValue(Int64(1024), forKey: "fileSize")
        return [mockResource] // Return mocked file size
    }
}
