//
//  PhotosPermissionManager.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import Photos

/// A permission manager for handling photo library access.
class PhotosPermissionManager: Permission {
    
    private var photoLibrary: PHPhotoLibraryProtocol.Type
    init(photoLibrary: PHPhotoLibraryProtocol.Type) {
        self.photoLibrary = photoLibrary
    }
    
    /// Requests authorization for photo library access.
    private func requestPhotoLibraryAuthorization() async -> PHAuthorizationStatus {
        await withCheckedContinuation { continuation in
            let status = photoLibrary.authorizationStatus()
            if status == .notDetermined {
                photoLibrary.requestAuthorization(for: .readWrite) { requestStatus in
                    continuation.resume(returning: requestStatus)
                }
            }
            else {
                continuation.resume(returning: status)
            }
        }
    }
    
    /// Requests permission to access the photo library.
    func requestPermission() async throws {
        let status = await requestPhotoLibraryAuthorization()

        switch status {
        case .authorized, .limited:
            return
        case .denied, .restricted, .notDetermined:
            throw StoreError.accessDenied("Access to photo library was denied.")
        @unknown default:
            throw StoreError.accessDenied("Unexpected authorization status.")
        }
    }
}
