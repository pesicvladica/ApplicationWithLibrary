//
//  RegistryError.swift
//
//
//  Created by Vladica Pesic on 12/10/24.
//

import Foundation

// MARK: - Custom Error Type

/// Errors that can occur during data fetching in the repository.
enum RegistryError: Error, CustomStringConvertible, Equatable {
    case storeNotFound
    
    /// Description of the error.
    public var description: String {
        switch self {
        case .storeNotFound:
            return "Store not found"
        }
    }
}
