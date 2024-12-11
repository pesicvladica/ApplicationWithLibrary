//
//  CentralRepository.swift
//
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation

/// A concrete implementation of the `FetchingRepository` protocol.
final class CentralRegistry: StoreRegistry {
    
    // MARK: Properties
    
    private var storeFactory: StoreFactory
    private var registeredStores: [StoreType: (any Store)?] // Dictionary to hold any type of store.
    
    // MARK: Initialization
    
    init(storeFactory: StoreFactory) {
        self.storeFactory = storeFactory
        self.registeredStores = [:]
    }
    
    // MARK: Private methods
    
    private func getStore(for key: StoreType) -> any Store {
        if let registeredStore = registeredStores[key], let store = registeredStore {
            return store
        }
        
        let storeToRegister = storeFactory.createStore(for: key)
        registeredStores[storeToRegister.storeKey] = storeToRegister
        return storeToRegister
    }
    
    // MARK: StoreRegistry
    
    func registerStores(_ stores: [StoreType]) {
        for store in stores {
            if !registeredStores.keys.contains(store) {
                registeredStores[store] = nil
            }
        }
    }
    
    func item(fromStoreForKey key: StoreType) async throws -> Any {
        guard let store = getStore(for: key) as? ItemStore else {
            throw RegistryError.storeNotFound
        }
        return try await store.fetchItem()
    }
    
    func items(fromStoreForKey key: StoreType, offset: Int, limit: Int) async throws -> [Any] {
        guard let store = getStore(for: key) as? ListStore else {
            throw RegistryError.storeNotFound
        }
        return try await store.fetchList(offset: offset, limit: limit)
    }
    
    func stream(forStoreKey key: StoreType) -> AsyncThrowingStream<Any, Error> {
        guard let store = getStore(for: key) as? StreamStore else {
            return AsyncThrowingStream { continuation in
                continuation.finish(throwing: RegistryError.storeNotFound)
            }
        }
        return store.stream()
    }
}
