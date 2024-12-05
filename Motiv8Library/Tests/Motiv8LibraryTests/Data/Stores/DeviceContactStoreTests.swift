//
//  DeviceContactStoreTests.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import XCTest
import Foundation
import Contacts
@testable import Motiv8Library

class DeviceContactStoreTests: XCTestCase {
    
    var mockPermissionManager: MockPermissionManager!
    var mockCNContactStore: MockCNContactStore!
    var sut: DeviceContactStore!

    override func setUp() {
        super.setUp()
        
        // Initialize mocks
        mockPermissionManager = MockPermissionManager(permissionGranted: true) // Default set to true
        mockCNContactStore = MockCNContactStore()
        
        // Initialize DeviceContactStore with mocks
        sut = DeviceContactStore(permissionManager: mockPermissionManager, contactStore: mockCNContactStore)
    }
    
    override func tearDown() {
        sut = nil
        mockPermissionManager = nil
        mockCNContactStore = nil
        super.tearDown()
    }
    
    func testDeviceContactStore_OnFetchContacts_Success() {
        // Arrange
        mockPermissionManager.permissionGranted = true
        mockCNContactStore.generateContacts()
                
        let expectation = self.expectation(description: #function)
        
        // Act
        sut.fetchList(offset: 0, limit: 10) { result in
            switch result {
            case .success(let contacts):
                // Assert
                XCTAssertEqual(contacts.count, 1)
                XCTAssertEqual(contacts[0].id, "1")
                XCTAssertEqual(contacts[0].title, "Name1 Surname1")
                XCTAssertEqual(contacts[0].phoneNumbers.count, 3)
                XCTAssertEqual(contacts[0].emails.count, 3)
                
            case .failure:
                XCTFail("Expected success, but got failure.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testDeviceContactStore_OnFetchContacts_PermissionDenied() {
        // Arrange
        mockPermissionManager.permissionGranted = false
        
        let expectation = self.expectation(description: #function)
        
        // Act
        sut.fetchList(offset: 0, limit: 10) { result in
            switch result {
            case .success:
                XCTFail("Expected failure due to permission denial, but got success.")
            case .failure(let error):
                // Assert
                XCTAssertEqual(error.localizedDescription, "Permission denied.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testDeviceContactStore_OnFetchContacts_NoContacts() {
        // Arrange
        mockPermissionManager.permissionGranted = true
        mockCNContactStore.contactsToReturn = []
        
        let expectation = self.expectation(description: #function)
        
        // Act
        sut.fetchList(offset: 0, limit: 10) { result in
            switch result {
            case .success(let contacts):
                // Assert
                XCTAssertTrue(contacts.isEmpty)
                
            case .failure:
                XCTFail("Expected success, but got failure.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testDeviceContactStore_OnFetchContacts_Pagination() {
        // Arrange
        mockPermissionManager.permissionGranted = true
        mockCNContactStore.generateContacts(20)
        
        let expectation = self.expectation(description: #function)
        
        let contactsLimit = 10
        
        // Act
        sut.fetchList(offset: 0, limit: contactsLimit) { result in
            switch result {
            case .success(let contacts):
                // Assert
                XCTAssertEqual(contacts.count, contactsLimit)
                XCTAssertEqual(contacts[0].id, "1")
                XCTAssertEqual(contacts[9].id, "10")
            case .failure:
                XCTFail("Expected success, but got failure.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
