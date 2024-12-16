//
//  MockListStore.swift
//  
//
//  Created by Vladica Pesic on 12/13/24.
//

import Foundation
@testable import Motiv8Library

class MockListStore: ListStore {
    
    var storeKey: any StoreType = MockStoreType.mockListStore
    
    func fetchList(offset: Int, limit: Int) async throws -> [Any] {
        let list = ["Item1", "Item2", "Item3"]
        
        var result = [String]()
        for i in offset..<(limit <= 3 ? limit : 3) {
            result.append(list[i])
        }
        return result
    }
}
