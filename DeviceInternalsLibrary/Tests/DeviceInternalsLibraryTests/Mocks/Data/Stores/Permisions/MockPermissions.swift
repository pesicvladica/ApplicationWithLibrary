//
//  MockPermissions.swift
//
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation
@testable import DeviceInternalsLibrary

// Mock for PermissionProtocol
class MockPermissions: Permission {
    var permissionGranted: Bool
    
    init(permissionGranted: Bool) {
        self.permissionGranted = permissionGranted
    }
    
    func requestPermission() async throws {
        if !permissionGranted {
            throw StoreError.accessDenied("Permission denied.")
        }
    }
}
