//
//  FetchingRepository.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

// MARK: Protocol definition

/// A protocol defining methods for fetching data from a repository.
public protocol FetchingRepository {
    
    /// Fetches a list of data items of a specified type.
    ///
    /// This method is used to fetch a paginated list of data items of a given type, with options for offset and limit.
    /// It calls the provided completion handler with the result of the fetch operation, which can either be
    /// a success with an array of items or an error if the fetch fails.
    ///
    /// - Parameters:
    ///    - type: The type of data to fetch (used to find the corresponding store).
    ///    - offset: The starting point for pagination (to fetch a subset of items).
    ///    - limit: The maximum number of items to return.
    ///    - onCompletion: A closure called with the result of the fetch operation.
    ///
    /// - Note: The method is designed to be used with any type that conforms to `Store` for the actual data retrieval.
    func fetchListData<T>(ofType type: T.Type, offset: Int, limit: Int, _ onCompletion: @escaping (Result<[T], Error>) -> Void)
    
    /// Fetches a single data item of a specified type.
    ///
    /// This method is used to fetch a single item of a specified type from the corresponding store. The provided
    /// completion handler will be called with the result of the fetch operation, which will either return the item
    /// or an error if the fetch fails.
    ///
    /// - Parameters:
    ///    - type: The type of data to fetch (used to find the corresponding store).
    ///    - onCompletion: A closure called with the result of the fetch operation.
    ///
    /// - Note: The method is designed to be used with any type that conforms to `Store` for the actual data retrieval.
    func fetchItemData<T>(ofType type: T.Type, _ onCompletion: @escaping (Result<T, Error>) -> Void)
}

// MARK: - Custom Error Type

/// Errors that can occur during data fetching in the repository.
public enum FetchingRepositoryError: Error, CustomStringConvertible, Equatable {
    case invalidData
    case custom(message: String)

    /// Description of the error.
    public var description: String {
        switch self {
        case .invalidData:
            return "The data fetched is invalid or incompatible."
        case .custom(let message):
            return message
        }
    }
}
