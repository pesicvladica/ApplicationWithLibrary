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
    associatedtype Item
    
    /// Fetches a single item and returns the result
    ///
    /// - Returns: Fetched item
    func fetchItem() async throws -> Item
    
    /// Fetches a list of items with pagination support (offset and limit).
    ///
    /// - Parameters:
    ///   - offset: The starting index for fetching items.
    ///   - limit: The maximum number of items to fetch.
    ///
    /// - Returns: List of fetched items
    func fetchList(offset: Int, limit: Int) async throws -> [Item]
    
    /// Provides a continuous stream of items.
    ///
    /// - Returns:Continuous strem of items
    func stream() -> AsyncThrowingStream<Item, Error>
}

// MARK: - Custom Error Type

/// Represents errors that can occur within the data stores.
public enum StoreError: Error, LocalizedError, Equatable {
    case methodNotSupported(String, String)
    case accessDenied(String)
    case fetchFailed(String)

    /// Custom error descriptions for each error case.
    public var errorDescription: String? {
        switch self {
        case .methodNotSupported(let component, let method):
            return "\(component) does not suppot \(method)" // Message detailing which component does not support specific method
        case .accessDenied(let message):
            return message // Message detailing why access was denied.
        case .fetchFailed(let message):
            return message // Message detailing why fetching failed.
        }
    }
}
