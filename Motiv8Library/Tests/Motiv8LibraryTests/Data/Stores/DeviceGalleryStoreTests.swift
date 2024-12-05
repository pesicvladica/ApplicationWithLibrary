//
//  DeviceGalleryStoreTests.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import XCTest
import Photos
@testable import Motiv8Library

class DeviceGalleryStoreTests: XCTestCase {

    var mockPermissionManager: MockPermissionManager!
    
    override func setUp() {
        super.setUp()
        mockPermissionManager = MockPermissionManager(permissionGranted: true)
    }
    
    override func tearDown() {
        mockPermissionManager = nil
        super.tearDown()
    }
    
    // MARK: Configuration
    
    func getImageSut() -> DeviceGalleryStore<ImageItem> {
        return DeviceGalleryStore<ImageItem>(mediaType: .image,
                                             permissionManager: mockPermissionManager,
                                             phAsset: MockPHAsset.self,
                                             phAssetResource: MockPHAssetResource.self)
    }
    
    func getVideoSut() -> DeviceGalleryStore<VideoItem> {
        return DeviceGalleryStore<VideoItem>(mediaType: .video,
                                             permissionManager: mockPermissionManager,
                                             phAsset: MockPHAsset.self,
                                             phAssetResource: MockPHAssetResource.self)
    }
    
    func setAssets(_ count: Int) {
        for i in 1..<(count + 1) {
            let mockPHAsset = MockPHAsset(localIdentifier: "\(i)",
                                          description: "Test Media \(i)",
                                          creationDate: Date(),
                                          pixelWidth: 1000 + i,
                                          pixelHeight: 1000 + i,
                                          duration: Double(i))
            MockPHAsset.assetFetchResult.assets.append(mockPHAsset)
        }
    }
    
    func clearAssets() {
        MockPHAsset.assetFetchResult.assets = []
    }
    
    // MARK: Test methods
    
    func testDeviceGalleryStore_OnImageFetch_Success() {
        // Arrange
        mockPermissionManager.permissionGranted = true
        
        let expectedMediaItem = ImageItem(id: "1",
                                          title: "Test Media 1",
                                          dateCreated: Date(),
                                          byteFileSize: 1024, 
                                          dimension: CGSize(width: 1001, height: 1001))
        self.setAssets(1)
        let sut = self.getImageSut()
        let expectation = self.expectation(description: #function)
        
        // Act
        sut.fetchList(offset: 0, limit: 10) { result in
            switch result {
            case .success(let items):
                // Assert
                XCTAssertEqual(items.count, 1, "Item count should be 1")
                XCTAssertEqual(items.first?.id, expectedMediaItem.id, "Fetched id doesn't match to provided id")
                XCTAssertEqual(items.first?.title, expectedMediaItem.title, "Fetched title doesn't match to provided id")
                XCTAssertEqual(items.first?.byteFileSize, expectedMediaItem.byteFileSize, "Fetched size doesn't match to provided size")
                XCTAssertEqual(items.first?.dimension, expectedMediaItem.dimension, "Fetched dimensions does not match to provided dimension")
            case .failure:
                XCTFail("Expected success, but got failure.")
            }
            expectation.fulfill()
        }
        
        self.clearAssets()
        wait(for: [expectation], timeout: 1)
    }
    
    func testDeviceGalleryStore_OnVideoFetch_Success() {
        // Arrange
        mockPermissionManager.permissionGranted = true
        
        let expectedMediaItem = VideoItem(id: "1",
                                          title: "Test Media 1",
                                          dateCreated: Date(),
                                          byteFileSize: 1024,
                                          duration: 1)
        self.setAssets(1)
        let sut = self.getVideoSut()
        let expectation = self.expectation(description: #function)
        
        // Act
        sut.fetchList(offset: 0, limit: 10) { result in
            switch result {
            case .success(let items):
                // Assert
                XCTAssertEqual(items.count, 1, "Item count should be 1")
                XCTAssertEqual(items.first?.id, expectedMediaItem.id, "Fetched id doesn't match to provided id")
                XCTAssertEqual(items.first?.title, expectedMediaItem.title, "Fetched title doesn't match to provided id")
                XCTAssertEqual(items.first?.byteFileSize, expectedMediaItem.byteFileSize, "Fetched size doesn't match to provided size")
                XCTAssertEqual(items.first?.duration, expectedMediaItem.duration, "Fetched duration does not match to provided duration")
            case .failure:
                XCTFail("Expected success, but got failure.")
            }
            expectation.fulfill()
        }
        
        self.clearAssets()
        wait(for: [expectation], timeout: 1)
    }
    
    func testDeviceGalleryStore_OnFetch_PermissionDenied() {
        // Arrange
        mockPermissionManager.permissionGranted = false
        
        let expectation = self.expectation(description: #function)
        let sut = self.getImageSut()
        
        // Act
        sut.fetchList(offset: 0, limit: 10) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success.")
            case .failure(let error):
                // Assert
                XCTAssertEqual(error as? StoreError, StoreError.fetchFailed("Permission denied."), "Should have returned Permission denied error")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testDeviceGalleryStore_OnFetch_NoResults() {
        // Arrange
        mockPermissionManager.permissionGranted = true
        
        let expectation = self.expectation(description: #function)
        
        self.clearAssets()
        let sut = self.getImageSut()
        
        // Act
        sut.fetchList(offset: 0, limit: 10) { result in
            switch result {
            case .success(let items):
                // Assert
                XCTAssertTrue(items.isEmpty, "Items list returned should be empty")
            case .failure:
                XCTFail("Expected success, but got failure.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
