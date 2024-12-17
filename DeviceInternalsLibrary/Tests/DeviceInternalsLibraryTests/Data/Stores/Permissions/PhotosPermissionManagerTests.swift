//
//  PhotosPermissionManagerTests.swift
//  
//
//  Created by Vladica Pesic on 12/17/24.
//

import XCTest
@testable import DeviceInternalsLibrary
import Photos

final class PhotosPermissionManagerTests: XCTestCase {
    
    var sut: PhotosPermissionManager!
    
    override func setUpWithError() throws {
        sut = PhotosPermissionManager(photoLibrary: MockPHPhotoLibrary.self)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testPhotosPermissionManager_OnRequestAccess_StatusNotDetermined() async {
        // Arrange
        MockPHPhotoLibrary.libraryAccessStatus = .notDetermined
        MockPHPhotoLibrary.libraryRequestedStatus = .denied
        
        // Act
        do {
            try await sut.requestPermission()
            XCTFail("Should have thrown error")
        }
        catch {
            
            // Assert
            XCTAssertNotNil(error as? StoreError, "Error should have been of type StoreError")
            XCTAssertEqual(error as? StoreError, StoreError.accessDenied("Access to photo library was denied."), "Error messages should match")
        }
    }
    
    func testPhotosPermissionManager_OnRequestAccess_StatusDenied() async {
        // Arrange
        MockPHPhotoLibrary.libraryAccessStatus = .denied
        
        // Act
        do {
            try await sut.requestPermission()
            XCTFail("Should have thrown error")
        }
        catch {
            
            // Assert
            XCTAssertNotNil(error as? StoreError, "Error should have been of type StoreError")
            XCTAssertEqual(error as? StoreError, StoreError.accessDenied("Access to photo library was denied."), "Error messages should match")
        }
    }
    
    func testPhotosPermissionManager_OnRequestAccess_UnknownStatus() async {
        // Arrange
        MockPHPhotoLibrary.libraryAccessStatus = PHAuthorizationStatus(rawValue: 42)!
        
        // Act
        do {
            try await sut.requestPermission()
            XCTFail("Should have thrown error")
        }
        catch {
            
            // Assert
            XCTAssertNotNil(error as? StoreError, "Error should have been of type StoreError")
            XCTAssertEqual(error as? StoreError, StoreError.accessDenied("Unexpected authorization status."), "Error messages should match")
        }
    }
    
    func testPhotosPermissionManager_OnRequestAccess_StatusAuthorized() async {
        // Arrange
        MockPHPhotoLibrary.libraryAccessStatus = .authorized
        
        // Act
        do {
            try await sut.requestPermission()
            XCTAssertTrue(true, "If access it allowed no error should be thrown")
        }
        catch {
            
            // Assert
            XCTFail("Should not have thrown error")
        }
    }
}
