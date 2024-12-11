//
//  File.swift
//  
//
//  Created by Vladica Pesic on 12/11/24.
//

import Foundation
import Photos

public protocol PHAssetProtocol {
    static func fetchAssets(with mediaType: PHAssetMediaType, options: PHFetchOptions?) -> PHFetchResult<PHAsset>
}

extension PHAsset: PHAssetProtocol {}
