//
//  Store.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

// MARK: Protocol definition

/// Protocol for data stores. The associated type `T` allows each store to fetch a specific type of item (e.g., contacts, images).
protocol StoreProtocol {
    associatedtype T
    
    /// Fetches a single item and returns the result through the completion handler.
    /// - Parameter onCompletion: A closure that returns either a success or failure result.
    func fetchItem(_ onCompletion: @escaping (Result<T, Error>) -> Void)
    
    /// Fetches a list of items with pagination support (offset and limit).
    /// - Parameters:
    ///   - offset: The starting index for fetching items.
    ///   - limit: The maximum number of items to fetch.
    ///   - onCompletion: A closure that returns either a success or failure result with the fetched list.
    func fetchList(offset: Int, limit: Int, _ onCompletion: @escaping (Result<[T], Error>) -> Void)
}

// MARK: Default implementation

/// A base class implementing the `StoreProtocol`. It provides default behaviors for `fetchItem` and `fetchList` methods, which are meant to be overridden by subclasses.
class Store<T>: StoreProtocol {
    
    /// Default implementation of `fetchItem` that returns a method not implemented error.
    /// - Parameter onCompletion: A closure that returns a failure result indicating that the method is not implemented.
    func fetchItem(_ onCompletion: @escaping (Result<T, Error>) -> Void) {
        onCompletion(.failure(StoreError.methodNotImplemented))
    }
    
    /// Default implementation of `fetchList` that returns a method not implemented error.
    /// - Parameters:
    ///   - offset: The starting index for fetching items.
    ///   - limit: The maximum number of items to fetch.
    ///   - onCompletion: A closure that returns a failure result indicating that the method is not implemented.
    func fetchList(offset: Int = 0, limit: Int = 0, _ onCompletion: @escaping (Result<[T], Error>) -> Void) {
        onCompletion(.failure(StoreError.methodNotImplemented))
    }
}

// MARK: - Custom Error Type

/// Represents errors that can occur within the data stores.
enum StoreError: Error, LocalizedError, Equatable {
    case methodNotImplemented
    case accessDenied(String)
    case fetchFailed(String)

    /// Custom error descriptions for each error case.
    var errorDescription: String? {
        switch self {
        case .methodNotImplemented:
            return "Method not implemented!" // Default message when a method isn't implemented.
        case .accessDenied(let message):
            return message // Message detailing why access was denied.
        case .fetchFailed(let message):
            return message // Message detailing why fetching failed.
        }
    }
}
