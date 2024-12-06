//
//  ItemFetcherProtocol.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation

/// A protocol defining a generic fetcher for retrieving items of type `Item`.
/// This can be implemented by various fetchers to collect specific types of data.
public protocol ItemFetcherProtocol {
    associatedtype Item
    
    /// Method to collect an item asynchronously.
    /// - Parameter onCompletion: A closure that returns a `Result` containing the fetched item of type `Item` or an `Error` if the fetch operation fails.
    func collect(_ onCompletion: @escaping (Result<Item, Error>) -> Void)
}

/// A specialized protocol for fetching device-specific information.
/// This protocol ensures that the fetched item is of type `DeviceItem`.
public protocol InfoItemFetcherProtocol: ItemFetcherProtocol where Item == DeviceItem {}
