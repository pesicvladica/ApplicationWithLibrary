//
//  RepositoryError.swift
//
//
//  Created by Vladica Pesic on 12/10/24.
//

import Foundation

// MARK: - Custom Error Type

/// Errors that can occur during data fetching in the repository.
enum RegistryError: Error, CustomStringConvertible, Equatable {
    case invalidData
    case storeNotFound
    
    /// Description of the error.
    public var description: String {
        switch self {
        case .invalidData:
            return "The data fetched is invalid or incompatible."
        case .storeNotFound:
            return "Store not found"
        }
    }
}
