//
//  FetcherError.swift
//
//
//  Created by Vladica Pesic on 12/10/24.
//

import Foundation

// MARK: - Custom Error Type

/// Errors that can occur during data fetching in use case.
public enum FetcherError: Error, CustomStringConvertible, Equatable {
    case custom(message: String)

    /// Description of the error.
    public var description: String {
        switch self {
        case .custom(let message):
            return message
        }
    }
}
