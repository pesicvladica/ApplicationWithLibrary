//
//  CentralRegistryTests.swift
//
//
//  Created by Vladica Pesic on 12/5/24.
//

import XCTest
@testable import DeviceInternalsLibrary

class CentralRegistryTests: XCTestCase {
    
    var mockStoreFactory: MockFactory!
    var sut: CentralRegistry!

    override func setUp() {
        super.setUp()
        
        mockStoreFactory = MockFactory()
        
        // Initialize CentralRegistry with mocks
        sut = CentralRegistry(storeFactory: mockStoreFactory)
    }
    
    override func tearDown() {
        mockStoreFactory = nil
        sut = nil
        super.tearDown()
    }
    
    func testCentralRegistry_OnRegisterUnknownStore_ThrowsError() {
        // Act
        do {
           try sut.registerStores([MockStoreType.mockItemStore])
            XCTFail("Should not return any store for unsupported store type")
        }
        catch {
            // Assert
            XCTAssertEqual(error as? RegistryError, RegistryError.storeNotFound, "For unsupported store type in central registry error should be store not found")
        }
    }
    
    func testCentralRegistry_OnRegisterStores_DoesntThrowError() {
        // Act, Assert
        XCTAssertNoThrow(try sut.registerStores([InternalType.deviceInfo, InternalType.contact]), "Should not return any store for unsupported store type")
    }
    
    func testCentralRegistry_OnGetItemFromUnregisteredStore_ThrowsError() async throws {
        // Arrange
        try sut.registerStores([InternalType.contact])
        
        // Act
        do {
            let _ = try await sut.item(fromStoreForKey: InternalType.contact)
            XCTFail("Should not return any item for store type that doesnt support item fetch")
        }
        catch {
            // Assert
            XCTAssertEqual(error as? RegistryError, RegistryError.storeNotFound, "For unsupported store type in central registry error should be store not found")
        }
    }
    
    func testCentralRegistry_OnGetItemFromRegisteredStore_DoesntThrowError() async throws {
        // Arrange
        try sut.registerStores([InternalType.deviceInfo])
        
        // Act
        do {
            let item = try await sut.item(fromStoreForKey: InternalType.deviceInfo)
            XCTAssertEqual(item as? String, "Item", "Should match item set to mocked data")
        }
        catch {
            // Assert
            XCTFail("Should not throw error for store type that supports item fetch")
        }
    }
    
    func testCentralRegistry_OnGetItemsFromUnregisteredStore_ThrowsError() async throws {
        // Arrange
        try sut.registerStores([InternalType.deviceInfo])
        
        // Act
        do {
            let _ = try await sut.items(fromStoreForKey: InternalType.deviceInfo, offset: 0, limit: 0)
            XCTFail("Should not return any items for store type that doesnt support items fetch")
        }
        catch {
            // Assert
            XCTAssertEqual(error as? RegistryError, RegistryError.storeNotFound, "For unsupported store type in central registry error should be store not found")
        }
    }
    
    func testCentralRegistry_OnGetItemsFromRegisteredStore_ThrowsErrorWithWrongLimit() async throws {
        // Arrange
        try sut.registerStores([InternalType.contact])
        
        // Act
        do {
            let _ = try await sut.items(fromStoreForKey: InternalType.contact, offset: 0, limit: 0)
            XCTFail("Should not return any items when limit is set to 0")
        }
        catch {
            // Assert
            XCTAssertEqual(error as? StoreError, StoreError.fetchFailed("Limit must be greater than zero."), "Should have thrown store error when limit is set to 0")
        }
    }
    
    func testCentralRegistry_OnGetItemsFromRegisteredStore_DoesntThrowError() async throws {
        // Arrange
        try sut.registerStores([InternalType.contact])
        
        // Act
        do {
            let items = try await sut.items(fromStoreForKey: InternalType.contact, offset: 0, limit: 10)
            XCTAssertEqual(items.count, 3, "Should match item count set to mocked data")
            XCTAssertEqual(items.first as? String, "Item1", "Item should match value set to mocked data")
            XCTAssertEqual(items.last as? String, "Item3", "Item should match value set to mocked data")
        }
        catch {
            // Assert
            XCTFail("Should not throw error for store type that supports items fetch")
        }
    }
}
