//
//  MockPHPhotoLibrary.swift
//  
//
//  Created by Vladica Pesic on 12/17/24.
//

import Foundation
import Photos
@testable import DeviceInternalsLibrary

class MockPHPhotoLibrary: PHPhotoLibraryProtocol {
    
    static var libraryAccessStatus: PHAuthorizationStatus = .authorized
    static var libraryRequestedStatus: PHAuthorizationStatus = .authorized
    
    static func authorizationStatus() -> PHAuthorizationStatus {
        return MockPHPhotoLibrary.libraryAccessStatus
    }
    
    static func requestAuthorization(for accessLevel: PHAccessLevel, handler: @escaping (PHAuthorizationStatus) -> Void) {
        handler(MockPHPhotoLibrary.libraryRequestedStatus)
    }
}
