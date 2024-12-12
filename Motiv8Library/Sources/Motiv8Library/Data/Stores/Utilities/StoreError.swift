//
//  StoreError.swift
//  
//
//  Created by Vladica Pesic on 12/10/24.
//

import Foundation

// MARK: - Custom Error Type

/// Errors that can occur during store operations.
enum StoreError: Error, LocalizedError, Equatable {
    case accessDenied(String)
    case fetchFailed(String)

    /// Custom error descriptions for each error case.
    public var errorDescription: String? {
        switch self {
        case .accessDenied(let message):
            return message // Message detailing why access was denied.
        case .fetchFailed(let message):
            return message // Message detailing why fetching failed.
        }
    }
}
