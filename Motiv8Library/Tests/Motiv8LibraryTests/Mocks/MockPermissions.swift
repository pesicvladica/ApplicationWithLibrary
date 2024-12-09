//
//  MockPermissions.swift
//  
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation
@testable import Motiv8Library

// Mock for PermissionProtocol
class MockPermissionManager: Permission {
    var permissionGranted: Bool
    
    init(permissionGranted: Bool) {
        self.permissionGranted = permissionGranted
    }
    
    func requestPermission(completion: @escaping (Result<Void, Error>) -> Void) {
        if permissionGranted {
            completion(.success(()))
        } else {
            completion(.failure(StoreError.fetchFailed("Permission denied.")))
        }
    }
}
