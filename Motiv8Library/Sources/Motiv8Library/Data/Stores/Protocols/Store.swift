//
//  Store.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

// MARK: Protocol definition

/// Protocol for data stores. The associated type `Item` allows each store to fetch a specific type of item (e.g., contacts, images).
public protocol Store {
    
    var storeKey: StoreKey { get }
    
    /// Fetches a single item and returns the result
    ///
    /// - Returns: Fetched item
    func fetchItem() async throws -> Any
    
    /// Fetches a list of items with pagination support (offset and limit).
    ///
    /// - Parameters:
    ///   - offset: The starting index for fetching items.
    ///   - limit: The maximum number of items to fetch.
    ///
    /// - Returns: List of fetched items
    func fetchList(offset: Int, limit: Int) async throws -> [Any]
    
    /// Provides a continuous stream of items.
    ///
    /// - Returns:Continuous strem of items
    func stream() -> AsyncThrowingStream<Any, Error>
}
