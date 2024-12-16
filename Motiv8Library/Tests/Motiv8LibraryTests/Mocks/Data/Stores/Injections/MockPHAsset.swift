//
//  MockPHAsset.swift
//  
//
//  Created by Vladica Pesic on 12/13/24.
//

import Foundation
import Photos
@testable import Motiv8Library

class MockPHAsset: PHAssetProtocol {
    
    static var assetsToReturn: [PHAsset] = []
    static func generateAssets(_ count: Int = 1) {
        var contacts = [MockPHAssets]()
        for i in 1..<(count + 1) {
            contacts.append(MockPHAssets(index: i))
        }
        MockPHAsset.assetsToReturn = contacts
    }
    
    static func fetchAssets(with mediaType: PHAssetMediaType, options: PHFetchOptions?) -> PHFetchResult<PHAsset> {
        
        let fetchResult = MockPHFetchResult(MockPHAsset.assetsToReturn)
        return fetchResult
    }
}
