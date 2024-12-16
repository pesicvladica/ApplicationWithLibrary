//
//  CentralRegistry.swift
//
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation

/// A central registry for managing and accessing stores.
final class CentralRegistry: StoreRegistry {
    
    // MARK: Properties
    
    private var storeFactory: StoreFactory
    private var registeredStores: [InternalType: (any Store)?] // Dictionary to hold any type of store.
    
    // MARK: Initialization
    
    /// Initializes a new central registry.
    /// - Parameters :
    ///   - storeFactory: The factory used to create store instances.
    ///
    init(storeFactory: StoreFactory) {
        self.storeFactory = storeFactory
        self.registeredStores = [:]
    }
    
    // MARK: Private methods
    
    /// Retrieves or creates a store for a given key.
    /// - Parameters :
    ///   - key: The type of store to retrieve or create.
    /// - Returns: 
    ///   - A store instance conforming to the `Store` protocol.
    /// - Precondition:
    ///   - The provided `key` must be an `InternalType`.
    private func getStore(for key: any StoreType) throws -> any Store {
        guard let internalKey = key as? InternalType else {
            throw RegistryError.storeNotFound
        }
        
        if let registeredStore = registeredStores[internalKey], let store = registeredStore {
            return store
        }
        
        let storeToRegister = try storeFactory.createStore(for: internalKey)
        registeredStores[internalKey] = storeToRegister
        return storeToRegister
    }
    
    // MARK: StoreRegistry
    
    /// Registers multiple stores.
    /// - Parameters :
    ///   - stores: An array of store types to register.
    /// - Precondition:
    ///   - All provided `stores` must be of type `InternalType`.
    func registerStores(_ stores: [any StoreType]) throws {
        guard let internalStores = stores as? [InternalType] else {
            throw RegistryError.storeNotFound
        }
        
        for store in internalStores {
            if !registeredStores.keys.contains(store) {
                registeredStores[store] = nil
            }
        }
    }
    
    /// Fetches a single item from a store.
    /// - Parameters :
    ///   - key: The key identifying the store.
    /// - Returns: 
    ///   - A single item fetched from the store.
    /// - Throws:
    ///   - `RegistryError.storeNotFound` if the store is not found.
    func item(fromStoreForKey key: any StoreType) async throws -> Any {
        guard let store = try getStore(for: key) as? ItemStore else {
            throw RegistryError.storeNotFound
        }
        return try await store.fetchItem()
    }
    
    /// Fetches a list of items from a store.
    /// - Parameters:
    ///   - key: The key identifying the store.
    ///   - offset: The starting index for the list fetch.
    ///   - limit: The maximum number of items to fetch.
    /// - Returns: 
    ///   - A list of items fetched from the store.
    /// - Throws:
    ///   - `RegistryError.storeNotFound` if the store is not found.
    func items(fromStoreForKey key: any StoreType, offset: Int, limit: Int) async throws -> [Any] {
        guard let store = try getStore(for: key) as? ListStore else {
            throw RegistryError.storeNotFound
        }
        guard limit > 0 else {
            throw StoreError.fetchFailed("Limit must be greater than zero.")
        }
        return try await store.fetchList(offset: offset, limit: limit)
    }
    
    // TODO: Implement stream functionality in future
    ///
    /// Returns a stream of items from a store.
    /// - Parameters :
    ///   - key: The key identifying the store.
    /// - Returns:
    ///   - An asynchronous stream of items from the store.
    func stream(forStoreKey key: any StoreType) -> AsyncThrowingStream<Any, Error> {
        return AsyncThrowingStream { continuation in
            continuation.finish(throwing: RegistryError.storeNotFound)
        }
    }
}
