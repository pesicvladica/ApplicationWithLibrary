//
//  MockPHFetchResult.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import Photos

class MockPHFetchResult: PHFetchResult<PHAsset> {
    var assets: [PHAsset]
    
    init(_ assets: [PHAsset]) {
        self.assets = assets
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

