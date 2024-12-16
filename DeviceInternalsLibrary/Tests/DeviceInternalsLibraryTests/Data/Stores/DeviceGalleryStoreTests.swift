//
//  DeviceGalleryStoreTests.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import XCTest
import Photos
@testable import DeviceInternalsLibrary

class DeviceGalleryStoreTests: XCTestCase {

    var mockPermissionManager: MockPermissions!
    var sutImage: DeviceGalleryStore!
    var sutVideo: DeviceGalleryStore!

    override func setUp() {
        super.setUp()
        
        // Initialize mocks
        mockPermissionManager = MockPermissions(permissionGranted: true) // Set initial to true
        
        // Initialize DeviceGalleryStore with mocks for image and video files
        sutImage = DeviceGalleryStore(mediaType: .image,
                                      permissionManager: mockPermissionManager,
                                      phAsset: MockPHAsset.self,
                                      phAssetResource: MockPHAssetResource.self)
        sutVideo = DeviceGalleryStore(mediaType: .video,
                                      permissionManager: mockPermissionManager,
                                      phAsset: MockPHAsset.self,
                                      phAssetResource: MockPHAssetResource.self)
    }
    
    override func tearDown() {
        mockPermissionManager = nil
        sutImage = nil
        sutVideo = nil
        super.tearDown()
    }

    func testDeviceGalleryStore_OnInitStoreKey_IsInternalImage() {
        // Assert
        XCTAssertEqual(sutImage.storeKey as? InternalType, InternalType.image, "Store key should be set to image")
    }
    
    func testDeviceGalleryStore_OnInitStoreKey_IsInternalVideo() {
        // Assert
        XCTAssertEqual(sutVideo.storeKey as? InternalType, InternalType.video, "Store key should be set to video")
    }
    
    func testDeviceGalleryStore_OnFetchImage_PermissionDenied() async {
        // Arrange
        mockPermissionManager.permissionGranted = false
        
        // Act
        do {
            let _ = try await sutImage.fetchList(offset: 0, limit: 10)
            XCTFail("Should have thrown error for denied permission to access images")
        }
        catch {
            // Assert
            XCTAssertEqual(error as? StoreError, .accessDenied("Permission denied."))
        }
    }
    
    func testDeviceGalleryStore_OnFetchVideo_PermissionDenied() async {
        // Arrange
        mockPermissionManager.permissionGranted = false
        
        // Act
        do {
            let _ = try await sutVideo.fetchList(offset: 0, limit: 10)
            XCTFail("Should have thrown error for denied permission to access video")
        }
        catch {
            // Assert
            XCTAssertEqual(error as? StoreError, .accessDenied("Permission denied."))
        }
    }

    func testDeviceGalleryStore_OnFetchUnsupportedMediaType_NoItems() async {
        // Arrange
        let sutUnknown = DeviceGalleryStore(mediaType: .unknown,
                                          permissionManager: mockPermissionManager,
                                          phAsset: MockPHAsset.self,
                                          phAssetResource: MockPHAssetResource.self)
        
        mockPermissionManager.permissionGranted = true
        MockPHAsset.generateAssets(20)
        
        // Act
        do {
            let unknown = try await sutUnknown.fetchList(offset: 0, limit: 10)
            
            // Assert
            XCTAssertTrue(unknown.isEmpty, "List should be empty but insted data was retrieved")
        }
        catch {
            XCTFail("Expected success with zero items, but got failure.")
        }
    }
    
    func testDeviceGalleryStore_OnFetchImage_NoItems() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        MockPHAsset.assetsToReturn = []
        
        // Act
        do {
            let images = try await sutImage.fetchList(offset: 0, limit: 10)
            
            // Assert
            XCTAssertTrue(images.isEmpty, "Image list should be empty but insted data was retrieved")
        }
        catch {
            XCTFail("Expected success with zero items, but got failure.")
        }
    }
    
    func testDeviceGalleryStore_OnFetchImage_Success() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        MockPHAsset.generateAssets()
        MockPHAssetResource.shouldReturnEmptyResources = false
        
        // Act
        do {
            guard let images = try await sutImage.fetchList(offset: 0, limit: 10) as? [ImageItem] else {
                XCTFail("Received items should be of type ImageItem")
                return
            }

            // Assert
            XCTAssertEqual(images.count, 1, "Item count shoud be 1.")
            XCTAssertEqual(images[0].id, "1", "First item should have id of 1")
            XCTAssertEqual(images[0].title, "Description 1", "Titles doesn't match")
            XCTAssertEqual(images[0].dateCreated, Date.distantPast, "Dates doesn't match")
            XCTAssertEqual(images[0].dimension, CGSize(width: 3201, height: 2301), "Dimensions should match")
            XCTAssertEqual(images[0].byteFileSize, 1024, "File size should match")
        }
        catch {
            XCTFail("Expected success with items, but got failure.")
        }
    }
    
    func testDeviceGalleryStore_OnFetchImage_FileSizeNotAvailable() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        MockPHAsset.generateAssets()
        MockPHAssetResource.shouldReturnEmptyResources = true
        
        // Act
        do {
            guard let images = try await sutImage.fetchList(offset: 0, limit: 10) as? [ImageItem] else {
                XCTFail("Received items should be of type ImageItem")
                return
            }

            // Assert
            XCTAssertEqual(images[0].byteFileSize, 0, "File size should be zero when not available")
        }
        catch {
            XCTFail("Expected success with items, but got failure.")
        }
    }
    
    func testDeviceGalleryStore_OnFetchImage_Pagination() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        MockPHAsset.generateAssets(20)
                
        let offset = 5
        let limit = 5
        
        // Act
        do {
            guard let images = try await sutImage.fetchList(offset: offset, limit: limit) as? [ImageItem] else {
                XCTFail("Received item should be of type ImageItem")
                return
            }
            
            // Assert
            XCTAssertEqual(images.count, limit, "Maximum items retrieved should be same as page limit")
            XCTAssertEqual(images[0].id, "6", "First item in fetched list doesnt match")
            XCTAssertEqual(images[4].id, "10", "Last item in fetched list doesnt match")
        }
        catch {
            XCTFail("Expected success with items, but got failure.")
        }
    }
    
    func testDeviceGalleryStore_OnFetchImage_LargerLimit() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        MockPHAsset.generateAssets(20)
                
        let offset = 15
        let limit = 10
        
        // Act
        do {
            guard let images = try await sutImage.fetchList(offset: offset, limit: limit) as? [ImageItem] else {
                XCTFail("Received item should be of type ImageItem")
                return
            }
            
            // Assert
            XCTAssertEqual(images.count, 5, "Maximum contacts retrieved should be same as page limit")
            XCTAssertEqual(images[0].id, "16", "First item in fetched list doesnt match")
            XCTAssertEqual(images[4].id, "20", "Last item in fetched list doesnt match")
        }
        catch {
            XCTFail("Expected success with items, but got failure.")
        }
    }

    func testDeviceGalleryStore_OnFetchVideos_NoItems() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        MockPHAsset.assetsToReturn = []
        
        // Act
        do {
            let videos = try await sutVideo.fetchList(offset: 0, limit: 10)
            
            // Assert
            XCTAssertTrue(videos.isEmpty, "Video list should be empty but insted data was retrieved")
        }
        catch {
            XCTFail("Expected success with zero items, but got failure.")
        }
    }
        
    func testDeviceGalleryStore_OnFetchVideos_Success() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        MockPHAsset.generateAssets()
        MockPHAssetResource.shouldReturnEmptyResources = false
        
        // Act
        do {
            guard let videos = try await sutVideo.fetchList(offset: 0, limit: 10) as? [VideoItem] else {
                XCTFail("Received items should be of type VideoItem")
                return
            }
            
            // Assert
            XCTAssertEqual(videos.count, 1, "Item count shoud be 1.")
            XCTAssertEqual(videos[0].id, "1", "First item should have id of 1")
            XCTAssertEqual(videos[0].title, "Description 1", "Titles doesn't match")
            XCTAssertEqual(videos[0].dateCreated, Date.distantPast, "Dates doesn't match")
            XCTAssertEqual(videos[0].duration, 31.0, "Durations should match")
            XCTAssertEqual(videos[0].byteFileSize, 1024, "File size should match")
        }
        catch {
            XCTFail("Expected success with items, but got failure.")
        }
    }
    
    func testDeviceGalleryStore_OnFetchVideos_FileSizeNotAvailable() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        MockPHAsset.generateAssets()
        MockPHAssetResource.shouldReturnEmptyResources = true
        
        // Act
        do {
            guard let videos = try await sutVideo.fetchList(offset: 0, limit: 10) as? [VideoItem] else {
                XCTFail("Received items should be of type VideoItem")
                return
            }

            // Assert
            XCTAssertEqual(videos[0].byteFileSize, 0, "File size should be zero when not available")
        }
        catch {
            XCTFail("Expected success with items, but got failure.")
        }
    }
        
    func testDeviceGalleryStore_OnFetchVideos_Pagination() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        MockPHAsset.generateAssets(20)
        
        let offset = 5
        let limit = 5
        
        // Act
        do {
            guard let videos = try await sutVideo.fetchList(offset: offset, limit: limit) as? [VideoItem] else {
                XCTFail("Received item should be of type VideoItem")
                return
            }
            
            // Assert
            XCTAssertEqual(videos.count, limit, "Maximum items retrieved should be same as page limit")
            XCTAssertEqual(videos[0].id, "6", "First item in fetched list doesnt match")
            XCTAssertEqual(videos[4].id, "10", "Last item in fetched list doesnt match")
        }
        catch {
            XCTFail("Expected success with items, but got failure.")
        }
    }
        
    func testDeviceGalleryStore_OnFetchVideos_LargerLimit() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        MockPHAsset.generateAssets(20)
        
        let offset = 15
        let limit = 10
        
        // Act
        do {
            guard let videos = try await sutVideo.fetchList(offset: offset, limit: limit) as? [VideoItem] else {
                XCTFail("Received item should be of type VideoItem")
                return
            }
            
            // Assert
            XCTAssertEqual(videos.count, 5, "Maximum contacts retrieved should be same as page limit")
            XCTAssertEqual(videos[0].id, "16", "First item in fetched list doesnt match")
            XCTAssertEqual(videos[4].id, "20", "Last item in fetched list doesnt match")
        }
        catch {
            XCTFail("Expected success with items, but got failure.")
        }
    }
}
