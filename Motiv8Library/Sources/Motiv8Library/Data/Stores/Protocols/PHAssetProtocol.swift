//
//  PHAssetProtocol.swift
//  
//
//  Created by Vladica Pesic on 12/11/24.
//

import Foundation
import Photos

/// Protocol for accessing photo assets.
public protocol PHAssetProtocol {
    /// Fetches photo assets of a specified media type.
    static func fetchAssets(with mediaType: PHAssetMediaType, options: PHFetchOptions?) -> PHFetchResult<PHAsset>
}

extension PHAsset: PHAssetProtocol {}
