//
//  Store.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

// MARK: Protocol definition

/// Base protocol for all stores, representing a generic store with a unique key.
public protocol Store {
    /// The key identifying the store.
    var storeKey: any StoreType { get }
}

/// Protocol for stores that provide a single item.
public protocol ItemStore: Store {
    
    /// Fetches a single item and returns the result
    ///
    /// - Returns: 
    ///   - Fetched item
    func fetchItem() async throws -> Any
}

/// Protocol for stores that provide a list of items.
public protocol ListStore: Store {
    
    /// Fetches a list of items with pagination support (offset and limit).
    ///
    /// - Parameters:
    ///   - offset: The starting index for fetching items.
    ///   - limit: The maximum number of items to fetch.
    ///
    /// - Returns: 
    ///   - List of fetched items
    func fetchList(offset: Int, limit: Int) async throws -> [Any]
}

/// Protocol for stores that provide a stream of items.
public protocol StreamStore: Store {
    
    /// Provides a continuous stream of items.
    ///
    /// - Returns:
    ///   - Continuous strem of items
    func stream() -> AsyncThrowingStream<Any, Error>
}
