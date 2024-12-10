//
//  CentralRepository.swift
//
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation

/// A concrete implementation of the `FetchingRepository` protocol.
public final class CentralRepository: FetchingRepository {
    
    // MARK: Properties
    
    private var stores: [StoreKey: any Store] = [:] // Dictionary to hold any type of store.
    
    // MARK: Initialization
    
    public init() {}
    
    // MARK: Fetching repository
    
    public func registerStore<T: Store>(_ store: T) {
        stores[store.storeKey] = store
    }
    
    public func fetchItem(fromStoreForKey key: StoreKey) async throws -> Any {
        guard let store = stores[key] as? ItemStore else {
            throw RepositoryError.storeNotFound
        }
        return try await store.fetchItem()
    }
    
    public func fetchItems(fromStoreForKey key: StoreKey, offset: Int, limit: Int) async throws -> [Any] {
        guard let store = stores[key] as? ListStore else {
            throw RepositoryError.storeNotFound
        }
        return try await store.fetchList(offset: offset, limit: limit)
    }
    
    public func itemStream(forStoreKey key: StoreKey) -> AsyncThrowingStream<Any, Error> {
        guard let store = stores[key] as? StreamStore else {
            return AsyncThrowingStream { continuation in
                continuation.finish(throwing: RepositoryError.storeNotFound)
            }
        }
        return store.stream()
    }
}
