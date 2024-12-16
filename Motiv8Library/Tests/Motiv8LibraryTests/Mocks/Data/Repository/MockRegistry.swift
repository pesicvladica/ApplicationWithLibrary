//
//  MockRegistry.swift
//  
//
//  Created by Vladica Pesic on 12/13/24.
//

import Foundation
@testable import Motiv8Library

class MockRegistry: StoreRegistry {
    
    private var storeFactory: StoreFactory = MockFactory()
    var registeredStores: [MockStoreType: (any Store)?] = [:]

    func registerStores(_ stores: [any StoreType]) throws {
        for store in (stores as! [MockStoreType]) {
            if !registeredStores.keys.contains(store) {
                registeredStores[store] = try storeFactory.createStore(for: store)
            }
        }
    }
    
    func item(fromStoreForKey key: any StoreType) async throws -> Any {
        guard let store = registeredStores[key as! MockStoreType] as? ItemStore else {
            throw RegistryError.storeNotFound
        }
        return try await store.fetchItem()
    }
    
    func items(fromStoreForKey key: any StoreType, offset: Int, limit: Int) async throws -> [Any] {
        guard let store = registeredStores[key as! MockStoreType] as? ListStore else {
            throw RegistryError.storeNotFound
        }
        return try await store.fetchList(offset: offset, limit: limit)
    }
    
    func stream(forStoreKey key: any StoreType) -> AsyncThrowingStream<Any, Error> {
        let store = registeredStores[key as! MockStoreType] as! StreamStore
        return store.stream()
    }
}
