//
//  MockFactory.swift
//
//
//  Created by Vladica Pesic on 12/13/24.
//

import Foundation
import Contacts
import Photos
import UIKit
@testable import Motiv8Library

final class MockFactory: StoreFactory {

    func createStore(for type: any StoreType) throws -> any Store {
        if let internalType = type as? InternalType {
            switch internalType {
            case .contact, .image, .video:
                return MockListStore()
            case .deviceInfo:
                return MockItemStore()
            }
        }
        else {
            switch type as! MockStoreType {
            case .mockListStore:
                return MockListStore()
            case .mockItemStore:
                return MockItemStore()
            }
        }
    }
}
