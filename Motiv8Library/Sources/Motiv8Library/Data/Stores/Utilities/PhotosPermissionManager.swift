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
class PhotosPermissionManager: PermissionProtocol {
    
    /// Requests permission to access the photo library. Calls the completion handler based on the status.
    /// - Parameter completion: A closure that returns a success or failure result based on the permission status.
    func requestPermission(completion: @escaping (Result<Void, Error>) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            completion(.success(())) // Access is granted.
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    completion(.success(()))
                }
                else {
                    completion(.failure(StoreError.accessDenied("Access to photo library was denied.")))
                }
            }
        default:
            completion(.failure(StoreError.accessDenied("Access to photo library was denied.")))
        }
    }
}
