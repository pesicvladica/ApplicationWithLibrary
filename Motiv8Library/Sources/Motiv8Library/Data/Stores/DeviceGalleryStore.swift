//
//  FetchingContactsRepository.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import Photos

/// A store for fetching media items (either images or videos) from the device's photo library.
class DeviceGalleryStore<T>: Store<T> where T: MediaItem {
    
    // MARK: Properties
    
    private let mediaType: PHAssetMediaType
    private let permissionManager: Permission
    private let phAsset: PHAsset.Type
    private let phAssetResource: PHAssetResource.Type
    
    // MARK: Initialization
    
    /// Initializes a new `DeviceGalleryStore` instance to fetch media items.
    ///
    /// - Parameters:
    ///    - mediaType: The type of media to fetch (`.image` or `.video`).
    ///    - permissionManager: An object conforming to `PermissionProtocol` for handling permission requests (defaults to `PhotosPermissionManager`).
    ///    - phAsset: The class used to fetch and manage photo assets (defaults to `PHAsset.self`).
    init(mediaType: PHAssetMediaType,
         permissionManager: Permission = PhotosPermissionManager(),
         phAsset: PHAsset.Type = PHAsset.self,
         phAssetResource: PHAssetResource.Type = PHAssetResource.self) {
        self.mediaType = mediaType
        self.permissionManager = permissionManager
        self.phAsset = phAsset
        self.phAssetResource = phAssetResource
    }

    // MARK: Private methods
    
    /// Creates a media item (either an image or video) based on the provided properties.
    ///
    /// - Parameters:
    ///    - identifier: A unique identifier for the media item.
    ///    - description: A description of the media item (e.g., filename or title).
    ///    - dateCreated: The creation date of the media item.
    ///    - fileSize: The file size of the media item in bytes.
    ///    - dimension: The dimensions (width and height) of the media item.
    ///    - duration: The duration of the media item (relevant for videos).
    ///
    /// - Returns: A `MediaItem` object of the appropriate type (`ImageItem` or `VideoItem`), or `nil` if the media type is unsupported.
    private func createMediaItem(identifier: String,
                                 description: String,
                                 dateCreated: Date,
                                 fileSize: Int64,
                                 dimension: CGSize,
                                 duration: Double) -> (any MediaItem)? {
        switch self.mediaType {
        case .image:
            return ImageItem(id: identifier,
                             title: description,
                             dateCreated: dateCreated,
                             byteFileSize: fileSize,
                             dimension: dimension)
        case .video:
            return VideoItem(id: identifier,
                             title: description,
                             dateCreated: dateCreated,
                             byteFileSize: fileSize,
                             duration: duration)
        default:
            return nil
        }
    }
    
    // MARK: Store<> methods
    
    /// Fetches a list of photo library items, respecting the given offset and limit. Requests permission before fetching.
    /// - Parameters:
    ///   - offset: The starting index for fetching items.
    ///   - limit: The maximum number of items to fetch.
    ///   - onCompletion: A closure that returns a success or failure result with the list of items.
    override func fetchList(offset: Int = 0, limit: Int = 0, _ onCompletion: @escaping (Result<[T], Error>) -> Void) {
        self.permissionManager.requestPermission { [weak self] result in
            guard let self else {
                onCompletion(.failure(StoreError.fetchFailed("Unexpected error.")))
                return
            }
            
            switch result {
            case .success():
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

                var mediaItems: [T] = []
                let results = self.phAsset.fetchAssets(with: self.mediaType, options: fetchOptions)
                results.enumerateObjects { asset, index, stop in
                    
                    // Stop enumerating if the number of processed items exceeds the requested limit and offset.
                    if index >= limit + offset {
                        stop.pointee = true
                    }
                    else if index >= offset {
                        
                        let identifier = asset.localIdentifier
                        let description = asset.description
                        let dateCreated = asset.creationDate ?? Date.distantPast
                        let fileSize = self.phAssetResource.assetResources(for: asset).first?.value(forKey: "fileSize") as? Int64 ?? 0
                        let dimension = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                        let duration = asset.duration
                        
                        // Create media item based on the media type (image or video)
                        if let mediaItem = self.createMediaItem(identifier: identifier,
                                                                description: description,
                                                                dateCreated: dateCreated,
                                                                fileSize: fileSize,
                                                                dimension: dimension,
                                                                duration: duration) as? T {
                            mediaItems.append(mediaItem)
                        }
                    }
                }

                onCompletion(.success(mediaItems))
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }
}
