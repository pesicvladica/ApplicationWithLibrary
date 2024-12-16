//
//  DeviceInfoStoreTests.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import XCTest
@testable import Motiv8Library

class DeviceInfoStoreTests: XCTestCase {

    var mockDevice: MockDevice!
    var mockWindowScene: MockWindowScene!
    var sut: DeviceInfoStore!
    
    override func setUp() {
        super.setUp()
        
        // Initialize mocks
        mockDevice = MockDevice(identifierForVendor: UUID(uuidString: "12345678-1234-1234-1234-1234567890AB"), systemName: "iOS", systemVersion: "14.1")
        mockWindowScene = MockWindowScene(withoutWindow: false)
        
        // Initialize DeviceInfoStore with mock UIDevice
        sut = DeviceInfoStore(device: mockDevice, windowScene: mockWindowScene)
    }
    
    override func tearDown() {
        mockDevice = nil
        mockWindowScene = nil
        sut = nil
        super.tearDown()
    }
    
    func testDeviceInfoStore_OnInitStoreKey_IsInternalDeviceInfo() {
        // Assert
        XCTAssertEqual(sut.storeKey as? InternalType, InternalType.deviceInfo, "Store key should be set to device info")
    }

    func testDeviceInfoStore_OnFetch_Success() async throws {
        // Arrange
        let expectedIdentifier = "12345678-1234-1234-1234-1234567890AB"
        let expectedSystemName = "iOS"
        let expectedSystemVersion = "14.1"
        
        guard let deviceItem = try await sut.fetchItem() as? DeviceItem else {
            XCTFail("Received item should be of type DeviceItem")
            return
        }
        
        // Assert
        XCTAssertEqual(deviceItem.id, expectedIdentifier, "Provided id shoudl match")
        XCTAssertEqual(deviceItem.title, expectedSystemName, "Provided system name should match")
        XCTAssertEqual(deviceItem.osVersion, expectedSystemVersion, "Provided os version should match")
        XCTAssertEqual(deviceItem.screenResolution, CGSize(width: 320, height: 480), "Should been default screensize")
    }
    
    func testDeviceInfoStore_OnFetch_OptionalsAreNil() async throws {
        // Arrange
        let nilIdDevice = MockDevice(identifierForVendor: nil, systemName: "iOS", systemVersion: "14.1")
        let nilSizeWindowScene = MockWindowScene(withoutWindow: true)
        let nilsSut = DeviceInfoStore(device: nilIdDevice, windowScene: nilSizeWindowScene)
        
        guard let deviceItem = try await nilsSut.fetchItem() as? DeviceItem else {
            XCTFail("Received item should be of type DeviceItem")
            return
        }
        
        // Assert
        XCTAssertEqual(deviceItem.id, "N/A", "Provided id shoudl match")
        XCTAssertEqual(deviceItem.screenResolution, CGSize(width: 0, height: 0), "Screen size should have been zero")
    }
}
