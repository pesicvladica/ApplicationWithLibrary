//
//  StoreError.swift
//  
//
//  Created by Vladica Pesic on 12/10/24.
//

import Foundation

// MARK: - Custom Error Type

/// Represents errors that can occur within the data stores.
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
