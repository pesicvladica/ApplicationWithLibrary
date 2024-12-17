//
//  File.swift
//  
//
//  Created by Vladica Pesic on 12/17/24.
//

import Foundation
import Photos

protocol PHPhotoLibraryProtocol {
    static func authorizationStatus() -> PHAuthorizationStatus
    static func requestAuthorization(for accessLevel: PHAccessLevel, handler: @escaping (PHAuthorizationStatus) -> Void)
}

extension PHPhotoLibrary: PHPhotoLibraryProtocol {}
