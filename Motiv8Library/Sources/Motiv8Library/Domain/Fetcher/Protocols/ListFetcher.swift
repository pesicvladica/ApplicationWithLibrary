//
//  ListFetcher.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation

/// A generic protocol to define the fetching behavior for a list of items.
/// - Note: The `I` associated type allows this protocol to be used for various data models.
public protocol ListFetcher<I> {
    /// The type of items being fetched.
    associatedtype I
    
    /// Prefetches all available items in the list.
    ///
    /// - Parameters:
    ///   - onCompletion: A closure called upon completion with either a result containing an array of fetched items or an error.
    ///
    func getItems(_ onCompletion: @escaping (Result<[I], Error>) -> Void)
    
    /// Fetches the next page of items in the list.
    /// 
    /// - Parameters:
    ///   -  onCompletion: A closure called upon completion with either a result containing an array of fetched items or an error.
    ///
    func getItems(at offset: Int, with limit: Int, _ onCompletion: @escaping (Result<[I], Error>) -> Void)
}
