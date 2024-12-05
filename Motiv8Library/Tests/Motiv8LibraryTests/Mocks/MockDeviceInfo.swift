//
//  MockDeviceInfo.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import UIKit
@testable import Motiv8Library

// MARK: - Mock Implementations

// Mock for UIDevice
class MockUIDevice: UIDevice {
    override var identifierForVendor: UUID? {
        return mockIdentifierForVendor
    }
    
    override var systemName: String {
        return mockSystemName
    }
    
    override var systemVersion: String {
        return mockSystemVersion
    }
    
    private var mockIdentifierForVendor: UUID?
    private var mockSystemName: String
    private var mockSystemVersion: String
    
    init(identifierForVendor: UUID? = nil, systemName: String = "iOS", systemVersion: String = "14.0") {
        self.mockIdentifierForVendor = identifierForVendor
        self.mockSystemName = systemName
        self.mockSystemVersion = systemVersion
        super.init()
    }
}
