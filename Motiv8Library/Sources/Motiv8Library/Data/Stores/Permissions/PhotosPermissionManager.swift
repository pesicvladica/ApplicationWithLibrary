//
//  PhotosPermissionManager.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import Photos

// MARK: - Utility for Gallery Permissions

/// A class that manages permission request for accessing the photo library.
class PhotosPermissionManager: Permission {
    
    private func requestPhotoLibraryAuthorization() async -> PHAuthorizationStatus {
        await withCheckedContinuation { continuation in
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { requestStatus in
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
            debugPrint("ALLOWED")
            return
        case .denied, .restricted:
            debugPrint("DENIED")
            throw StoreError.accessDenied("Access to photo library was denied.")
        case .notDetermined:
            /// This should not happen since in request we check if state is not determined and request acces if needed
            debugPrint("NOT DETERMINED!")
            return
        @unknown default:
            debugPrint("UNKNOWN")
            throw StoreError.accessDenied("Unexpected authorization status.")
        }
    }
}
