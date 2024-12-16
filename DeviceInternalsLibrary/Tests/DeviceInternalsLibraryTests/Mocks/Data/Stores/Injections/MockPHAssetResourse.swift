//
//  MockPHAssetResource.swift
//  
//
//  Created by Vladica Pesic on 12/13/24.
//

import Foundation
import Photos
@testable import DeviceInternalsLibrary

class MockPHAssetResource: PHAssetResourceProtocol {
    
    static var shouldReturnEmptyResources = false
    
    static func assetResources(for asset: PHAsset) -> [PHAssetResource] {
        if MockPHAssetResource.shouldReturnEmptyResources {
            return []
        }
        else {
            let mockResource = MockPHAssetsResource()
            mockResource.setValue(Int64(1024), forKey: "fileSize")
            return [mockResource]
        }
    }
}
