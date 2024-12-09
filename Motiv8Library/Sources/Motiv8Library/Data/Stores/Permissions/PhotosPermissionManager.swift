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
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                continuation.resume(returning: status)
            }
        }
    }
    
    /// Requests permission to access the photo library.
    func requestPermission() async throws {
        Task {
            let status = await requestPhotoLibraryAuthorization()

            switch status {
            case .authorized, .limited:
                return
            case .denied, .restricted:
                throw StoreError.accessDenied("Access to photo library was denied.")
            case .notDetermined:
                try await requestPermission()
            @unknown default:
                throw StoreError.accessDenied("Unexpected authorization status.")
            }
        }
    }
}
