//
//  MainStoreFactoryTests.swift
//
//
//  Created by Vladica Pesic on 12/16/24.
//

import XCTest
@testable import Motiv8Library

class MainStoreFactoryTests: XCTestCase {
    
    var sut: MainStoreFactory!

    override func setUp() {
        super.setUp()
        
        // Initialize MainStoreFactory 
        sut = MainStoreFactory()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testMainStoreFactory_OnCreateUnknownStore_ThrowsError() {
        // Act
        do {
            let _ = try sut.createStore(for: MockStoreType.mockItemStore)
            XCTFail("Should not return any store for unsupported store type")
        }
        catch {
            // Assert
            XCTAssertEqual(error as? StoreError, StoreError.storeNotFound("Main store factory only supports Internal types"), "For unsupported store type in main factory error should be store not found")
        }
    }
    
    func testMainStoreFactory_OnCreateContactStore_StoreIsCreated() {
        // Act
        do {
            let store = try sut.createStore(for: InternalType.contact)
            
            // Assert
            XCTAssertNotNil(store as? DeviceContactStore, "Returned store should be of type DeviceContactStore")
        }
        catch {
            // Assert
            XCTFail("Should not have returned any error for supported store type")
        }
    }
    
    func testMainStoreFactory_OnCreateImageStore_StoreIsCreated() {
        // Act
        do {
            let store = try sut.createStore(for: InternalType.image)
            
            // Assert
            XCTAssertNotNil(store as? DeviceGalleryStore, "Returned store should be of type DeviceGalleryStore")
            XCTAssertEqual((store as? DeviceGalleryStore)?.storeKey as? InternalType, InternalType.image, "Gallery store type should be image")

        }
        catch {
            // Assert
            XCTFail("Should not have returned any error for supported store type")
        }
    }
    
    func testMainStoreFactory_OnCreateVideoStore_StoreIsCreated() {
        // Act
        do {
            let store = try sut.createStore(for: InternalType.video)
            
            // Assert
            XCTAssertNotNil(store as? DeviceGalleryStore, "Returned store should be of type DeviceGalleryStore")
            XCTAssertEqual((store as? DeviceGalleryStore)?.storeKey as? InternalType, InternalType.video, "Gallery store type should be video")
        }
        catch {
            // Assert
            XCTFail("Should not have returned any error for supported store type")
        }
    }
    
    func testMainStoreFactory_OnCreateDeviceInfoStore_StoreIsCreated() {
        do {
            let store = try sut.createStore(for: InternalType.deviceInfo)
            
            // Assert
            XCTAssertNotNil(store as? DeviceInfoStore, "Returned store should be of type DeviceInfoStore")
        }
        catch {
            // Assert
            XCTFail("Should not have returned any error for supported store type")
        }
    }
}
