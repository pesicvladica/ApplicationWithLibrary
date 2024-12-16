//
//  DeviceContactStoreTests.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import XCTest
import Foundation
import Contacts
@testable import DeviceInternalsLibrary

class DeviceContactStoreTests: XCTestCase {
    
    var mockPermissionManager: MockPermissions!
    var mockCNContactStore: MockCNContactStore!
    var sut: DeviceContactStore!

    override func setUp() {
        super.setUp()
        
        // Initialize mocks
        mockPermissionManager = MockPermissions(permissionGranted: true) // Set initial to true
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
    
    func testDeviceContactStore_OnInitStoreKey_IsInternalContact() {
        // Assert
        XCTAssertEqual(sut.storeKey as? InternalType, InternalType.contact, "Store key should be set to contact")
    }
    
    func testDeviceContactStore_OnFetchContacts_PermissionDenied() async {
        // Arrange
        mockPermissionManager.permissionGranted = false
        
        // Act
        do {
            let _ = try await sut.fetchList(offset: 0, limit: 10)
            XCTFail("Should have thrown error for denied permission to access contacts")
        }
        catch {
            // Assert
            XCTAssertEqual(error as? StoreError, .accessDenied("Permission denied."))
        }
    }
    
    func testDeviceContactStore_OnFetchContacts_FetchFails() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        mockCNContactStore.shouldThrowError = true
                
        // Act
        do {
            let _ = try await sut.fetchList(offset: 0, limit: 10)
            XCTFail("Should have thrown error for failed fetch")
        }
        catch {
            // Assert
            XCTAssertEqual(error as? StoreError, .fetchFailed("Failed to fetch contacts."))
        }
    }
    
    func testDeviceContactStore_OnFetchContacts_NoContacts() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        mockCNContactStore.shouldThrowError = false
        mockCNContactStore.contactsToReturn = []
        
        // Act
        do {
            let contacts = try await sut.fetchList(offset: 0, limit: 10)
            
            // Assert
            XCTAssertTrue(contacts.isEmpty, "Contact list should be empty but insted data was retrieved")
        }
        catch {
            XCTFail("Expected success with zero items, but got failure.")
        }
    }
    
    func testDeviceContactStore_OnFetchContacts_Success() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        mockCNContactStore.shouldThrowError = false
        mockCNContactStore.generateContacts()
        
        // Act
        do {
            guard let contacts = try await sut.fetchList(offset: 0, limit: 10) as? [ContactItem] else {
                XCTFail("Received contacts should be of type ContactItem")
                return
            }
            
            // Assert
            XCTAssertEqual(contacts.count, 1, "Item count shoud be 1.")
            XCTAssertEqual(contacts[0].id, "1", "First item should have id of 1")
            XCTAssertEqual(contacts[0].title, "Name1 Surname1", "Name doesn't match")
            XCTAssertEqual(contacts[0].phoneNumbers.count, 3, "Number of phone numbers should be 3")
            XCTAssertEqual(contacts[0].emails.count, 3, "Number of emails should be 3")
        }
        catch {
            XCTFail("Expected success with items, but got failure.")
        }
    }
    
    func testDeviceContactStore_OnFetchContacts_Pagination() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        mockCNContactStore.shouldThrowError = false
        mockCNContactStore.generateContacts(20)
                
        let offset = 5
        let limit = 5
        
        // Act
        do {
            guard let contacts = try await sut.fetchList(offset: offset, limit: limit) as? [ContactItem] else {
                XCTFail("Received contacts should be of type ContactItem")
                return
            }
            
            // Assert
            XCTAssertEqual(contacts.count, limit, "Maximum contacts retrieved should be same as page limit")
            XCTAssertEqual(contacts[0].id, "6", "First item in fetched list doesnt match")
            XCTAssertEqual(contacts[4].id, "10", "Last item in fetched list doesnt match")
        }
        catch {
            XCTFail("Expected success with items, but got failure.")
        }
    }
    
    func testDeviceContactStore_OnFetchContacts_LargerLimit() async {
        // Arrange
        mockPermissionManager.permissionGranted = true
        mockCNContactStore.shouldThrowError = false
        mockCNContactStore.generateContacts(20)
                
        let offset = 15
        let limit = 10
        
        // Act
        do {
            guard let contacts = try await sut.fetchList(offset: offset, limit: limit) as? [ContactItem] else {
                XCTFail("Received contacts should be of type ContactItem")
                return
            }
            
            // Assert
            XCTAssertEqual(contacts.count, 5, "Maximum contacts retrieved should be same as page limit")
            XCTAssertEqual(contacts[0].id, "16", "First item in fetched list doesnt match")
            XCTAssertEqual(contacts[4].id, "20", "Last item in fetched list doesnt match")
        }
        catch {
            XCTFail("Expected success with items, but got failure.")
        }
    }
}
