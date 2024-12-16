//
//  MockDevice.swift
//
//
//  Created by Vladica Pesic on 12/13/24.
//

import Foundation
@testable import DeviceInternalsLibrary

class MockDevice: DeviceProtocol {
    
    var identifierForVendor: UUID? {
        return mockIdentifierForVendor
    }
    
    var systemName: String {
        return mockSystemName
    }
    
    var systemVersion: String {
        return mockSystemVersion
    }
    
    private var mockIdentifierForVendor: UUID?
    private var mockSystemName: String
    private var mockSystemVersion: String
    
    init(identifierForVendor: UUID?, systemName: String, systemVersion: String) {
        self.mockIdentifierForVendor = identifierForVendor
        self.mockSystemName = systemName
        self.mockSystemVersion = systemVersion
    }
}
