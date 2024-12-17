//
//  ContactPermissionManagerTests.swift
//  
//
//  Created by Vladica Pesic on 12/17/24.
//

import XCTest
@testable import DeviceInternalsLibrary

final class ContactPermissionManagerTests: XCTestCase {
    
    var mockContactStore: MockCNContactStore!
    var sut: ContactPermissionManager!
    
    override func setUpWithError() throws {
        mockContactStore = MockCNContactStore()
        sut = ContactPermissionManager(contactStore: mockContactStore)
    }

    override func tearDownWithError() throws {
        mockContactStore = nil
        sut = nil
    }

    func testContactPermissionManager_OnAccessRequest_PermissionDenied() async {
        // Arrange
        mockContactStore.accessGranted = false
        mockContactStore.accessError = StoreError.accessDenied("Wrong permission requested")
        
        // Act
        do {
            try await sut.requestPermission()
            XCTFail("Should have thrown error")
        }
        catch {
            // Assert
            XCTAssertNotNil(error as? StoreError, "Error thrown should be of type StoreError")
            XCTAssertEqual(error as? StoreError, StoreError.accessDenied("Wrong permission requested"), "Errors should match")
        }
    }
    
    func testContactPermissionManager_OnAccessRequest_PermissionDeniedWithoutError() async {
        // Arrange
        mockContactStore.accessGranted = false
        mockContactStore.accessError = nil
        
        // Act
        do {
            try await sut.requestPermission()
            XCTFail("Should have thrown error")
        }
        catch {
            // Assert
            XCTAssertNotNil(error as? StoreError, "Error thrown should be of type StoreError")
            XCTAssertEqual(error as? StoreError, StoreError.accessDenied("Access to contacts was denied."), "Errors should match")
        }
    }
    
    func testContactPermissionManager_OnAccessRequest_PermissionAllowed() async {
        // Arrange
        mockContactStore.accessGranted = true
        mockContactStore.accessError = nil
        
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
