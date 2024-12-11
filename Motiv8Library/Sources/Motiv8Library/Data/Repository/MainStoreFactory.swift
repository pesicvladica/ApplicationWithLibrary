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

final class MainStoreFactory: StoreFactory {
    func createStore(for type: StoreType) -> any Store {
        switch type {
        case .contact:
            let permissionManager = ContactPermissionManager()
            let contactStore = CNContactStore()
            return DeviceContactStore(permissionManager: permissionManager,
                                      contactStore: contactStore)
        case .image, .video:
            let mediaType = type == StoreType.image ? 
                                PHAssetMediaType.image :
                                PHAssetMediaType.video
            let permissionManager = PhotosPermissionManager()
            let phAsset = PHAsset.self
            let phAssetResource = PHAssetResource.self
            return DeviceGalleryStore(mediaType: mediaType,
                                      permissionManager: permissionManager,
                                      phAsset: phAsset,
                                      phAssetResource: phAssetResource)
        case .deviceInfo:
            let device = UIDevice.current
            let application = UIApplication.shared
            return DeviceInfoStore(device: device, 
                                   application: application)
        }
    }
}
