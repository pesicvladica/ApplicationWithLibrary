//
//  ItemFetcher.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation

/// A protocol defining a generic fetcher for retrieving items of type `I`.
/// This can be implemented by various fetchers to collect specific types of data.
public protocol ItemFetcher<I> {
    associatedtype I
    
    /// Method to collect an item asynchronously.
    /// 
    /// - Parameters:
    ///   - onCompletion: A closure that returns a `Result` containing the fetched item of type `Item` or an `Error` if the fetch operation fails.
    ///
    func getItem(_ onCompletion: @escaping (Result<I, Error>) -> Void)
}
