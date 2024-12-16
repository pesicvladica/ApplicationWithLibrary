//
//  MockItemStore.swift
//  
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation
@testable import Motiv8Library

class MockItemStore: ItemStore {

    var storeKey: any StoreType = MockStoreType.mockItemStore
    
    func fetchItem() async throws -> Any {
        return "Item"
    }
}
