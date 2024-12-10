//
//  RepositoryError.swift
//
//
//  Created by Vladica Pesic on 12/10/24.
//

import Foundation

// MARK: - Custom Error Type

/// Errors that can occur during data fetching in the repository.
public enum RepositoryError: Error, CustomStringConvertible, Equatable {
    case invalidData
    
    case storeNotFound
    case invalidStoreType
    case fetchFailed
    
    case custom(message: String)

    /// Description of the error.
    public var description: String {
        switch self {
        case .invalidData:
            return "The data fetched is invalid or incompatible."
        case .custom(let message):
            return message
        case .storeNotFound:
            return "."
        case .invalidStoreType:
            return "."
        case .fetchFailed:
            return "."
        }
    }
}
