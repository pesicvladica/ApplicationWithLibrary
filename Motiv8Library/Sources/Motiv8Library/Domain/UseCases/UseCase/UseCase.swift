//
//  File.swift
//  
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation

/// Base class for use cases interacting with repositories.
open class UseCase {
    
    // MARK: Properties
    
    let repository: GenericFetchingRepository
    
    // MARK: Initialization
    
    /// Initializes the use case with a specified repository.
    ///
    /// This initializer sets up the `UseCase` with a repository that handles data fetching. The repository is used
    /// by the use case to fetch the required data from various stores. The use case can be expanded to include business
    /// logic or other operations in addition to data retrieval.
    ///
    /// - Parameter repository: The repository responsible for fetching data.
    init(repository: GenericFetchingRepository) {
        self.repository = repository
    }
}

// MARK: - Custom Error Type

/// Errors that can occur during data fetching in use case.
enum UseCaseError: Error, CustomStringConvertible, Equatable {
    case fetchFailed
    case custom(message: String)

    /// Description of the error.
    var description: String {
        switch self {
        case .fetchFailed:
            return "Could not fetch data!"
        case .custom(let message):
            return message
        }
    }
}