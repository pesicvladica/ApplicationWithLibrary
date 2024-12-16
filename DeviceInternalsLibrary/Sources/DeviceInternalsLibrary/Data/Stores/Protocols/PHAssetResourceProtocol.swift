//
//  PHAssetResourceProtocol.swift
//  
//
//  Created by Vladica Pesic on 12/11/24.
//

import Foundation
import Photos

/// Protocol for accessing metadata about photo asset resources.
public protocol PHAssetResourceProtocol {
    /// Returns the resources associated with a given asset.
    static func assetResources(for asset: PHAsset) -> [PHAssetResource]
}

extension PHAssetResource: PHAssetResourceProtocol {}
