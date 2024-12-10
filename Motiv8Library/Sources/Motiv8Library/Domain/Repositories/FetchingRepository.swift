//
//  FetchingRepository.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

// MARK: Protocol definition

/// A protocol that defines methods for managing and retrieving data from multiple stores in a central repository.
public protocol FetchingRepository {
    
    /// Registers a store in the repository with the specified key.
    ///
    /// - Parameters:
    ///   - store: The store to register. It must conform to the `Store` protocol.
    ///   - key: The unique key to associate with the store.
    ///
    /// - Note: Registering a store with an existing key will overwrite the previous store.
    func registerStore<T: Store>(_ store: T)
    
    /// Fetches a single item from the store associated with the given key.
    ///
    /// - Parameter key: The key identifying the store to fetch the item from.
    /// - Returns: The fetched item as `Any`. The exact type depends on the store implementation.
    /// - Throws: An error if the store is not found or if the fetch operation fails.
    ///
    /// - Note: The return type is `Any`, so callers are responsible for casting it to the expected type.
    func fetchItem(fromStoreForKey key: StoreKey) async throws -> Any
    
    /// Fetches a paginated list of items from the store associated with the given key.
    ///
    /// - Parameters:
    ///   - key: The key identifying the store to fetch the items from.
    ///   - offset: The starting point for pagination (used to fetch a subset of items).
    ///   - limit: The maximum number of items to return.
    /// - Returns: A list of fetched items as `[Any]`. The exact type of each item depends on the store implementation.
    /// - Throws: An error if the store is not found or if the fetch operation fails.
    ///
    /// - Note: The return type is `[Any]`, so callers are responsible for casting the items to the expected type.
    func fetchItems(fromStoreForKey key: StoreKey, offset: Int, limit: Int) async throws -> [Any]
    
    /// Provides a stream of items from the store associated with the given key.
    ///
    /// - Parameter key: The key identifying the store to stream items from.
    /// - Returns: An `AsyncThrowingStream` that produces items as `Any`. The exact type of each item depends on the store implementation.
    ///            Returns `nil` if the store does not support streaming or is not found.
    ///
    /// - Note: The returned stream emits items of type `Any`. Callers are responsible for casting the items to the expected type.
    func itemStream(forStoreKey key: StoreKey) -> AsyncThrowingStream<Any, Error>
}
