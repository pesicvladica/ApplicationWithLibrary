//
//  MainStoreFactory.swift
//
//
//  Created by Vladica Pesic on 12/11/24.
//

import Foundation
import Contacts
import Photos
import UIKit

/// A factory for creating instances of stores.
final class MainStoreFactory: StoreFactory {
    
    /// Creates a store instance for the specified store type.
    /// - Parameters:
    ///   - type : The type of store to create.
    /// - Returns :
    ///   - A store instance conforming to the `Store` protocol.
    /// - Precondition :
    ///   - The provided `type` must be an `InternalType`.
    func createStore(for type: any StoreType) throws -> any Store {
        guard let internalType = type as? InternalType else {
            throw StoreError.storeNotFound("Main store factory only supports Internal types")
        }
        
        switch internalType {
        case .contact:
            let contactStore = CNContactStore()
            let permissionManager = ContactPermissionManager(contactStore: contactStore)
            return DeviceContactStore(permissionManager: permissionManager, contactStore: contactStore)
        case .image, .video:
            let mediaType = internalType == .image ? PHAssetMediaType.image : PHAssetMediaType.video
            
            let permissionManager = PhotosPermissionManager(photoLibrary: PHPhotoLibrary.self)
            let phAsset = PHAsset.self
            let phAssetResource = PHAssetResource.self
            
            return DeviceGalleryStore(mediaType: mediaType,
                                      permissionManager: permissionManager,
                                      phAsset: phAsset,
                                      phAssetResource: phAssetResource)
        case .deviceInfo:
            let device = UIDevice.current
            let windowScene = UIApplication.shared.connectedScenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene

            return DeviceInfoStore(device: device,
                                   windowScene: windowScene)
        }
    }
}
