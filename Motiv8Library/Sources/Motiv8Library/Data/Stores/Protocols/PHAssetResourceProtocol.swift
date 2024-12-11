//
//  File.swift
//  
//
//  Created by Vladica Pesic on 12/11/24.
//

import Foundation
import Photos

public protocol PHAssetResourceProtocol {
    static func assetResources(for asset: PHAsset) -> [PHAssetResource]
}

extension PHAssetResource: PHAssetResourceProtocol {}
