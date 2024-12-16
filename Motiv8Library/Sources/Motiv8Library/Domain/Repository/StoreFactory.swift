//
//  StoreFactory.swift
//
//
//  Created by Vladica Pesic on 12/11/24.
//

import Foundation

/// A protocol for defining a factory that creates store instances.
public protocol StoreFactory {
    
    /// Creates a store for the specified type.
    /// - Parameters:
    ///   - type: The type of the store to create.
    /// - Returns:
    ///   - A store instance conforming to the `Store` protocol.
    /// - Throws:
    ///   - An error if the store is not found
    ///   
    func createStore(for type: any StoreType) throws -> any Store
}
