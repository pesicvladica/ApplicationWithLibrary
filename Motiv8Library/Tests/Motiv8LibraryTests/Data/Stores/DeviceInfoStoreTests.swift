//
//  DeviceInfoStoreTests.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import XCTest
@testable import Motiv8Library

class DeviceInfoStoreTests: XCTestCase {

    var mockUIDevice: MockUIDevice!
    var sut: DeviceInfoStore!
    
    override func setUp() {
        super.setUp()
        
        // Initialize mocks
        mockUIDevice = MockUIDevice(identifierForVendor: UUID(uuidString: "12345678-1234-1234-1234-1234567890AB"), 
                                    systemName: "iOS",
                                    systemVersion: "14.1")
        
        // Initialize DeviceInfoStore with mock UIDevice
        sut = DeviceInfoStore(device: mockUIDevice)
    }
    
    override func tearDown() {
        mockUIDevice = nil
        sut = nil
        super.tearDown()
    }

    func testDeviceInfoStore_OnFetch_Success() {
        // Arrange
        let expectedIdentifier = "12345678-1234-1234-1234-1234567890AB"
        let expectedSystemName = "iOS"
        let expectedSystemVersion = "14.1"

        let expectation = self.expectation(description: #function)
        
        // Act
        sut.fetchItem { result in
            switch result {
            case .success(let deviceItem):
                // Assert
                XCTAssertEqual(deviceItem.id, expectedIdentifier, "Provided id shoudl match")
                XCTAssertEqual(deviceItem.title, expectedSystemName, "Provided system name should match")
                XCTAssertEqual(deviceItem.osVersion, expectedSystemVersion, "Provided os version should match")
                XCTAssertEqual(deviceItem.manufacturer, "Apple", "Manufacturers should match")
            case .failure:
                XCTFail("Expected success, but got failure.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }

    func testDeviceInfoStore_OnFetch_IdentifierForVendorNil() {
        // Arrange
        mockUIDevice = MockUIDevice(identifierForVendor: nil, systemName: "iOS", systemVersion: "14.1")
        sut = DeviceInfoStore(device: mockUIDevice)
        
        let expectedIdentifier = "N/A" // Expected value when identifierForVendor is nil
        
        let expectation = self.expectation(description: #function)
        
        // Act
        sut.fetchItem { result in
            switch result {
            case .success(let deviceItem):
                // Assert
                XCTAssertEqual(deviceItem.id, expectedIdentifier, "Identifier should be undefined")
            case .failure:
                XCTFail("Expected success, but got failure.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
