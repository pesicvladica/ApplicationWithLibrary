//
//  ListFetcherProtocol.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation

/// A generic protocol to define the fetching behavior for a list of items.
/// - Note: The `Item` associated type allows this protocol to be used for various data models.
public protocol ListFetcherProtocol {
    /// The type of items being fetched.
    associatedtype Item
    
    /// Prefetches all available items in the list.
    /// - Parameter onPrefetched: A closure called upon completion with either a result containing an array of fetched items or an error.
    func prefetchAllItems(_ onPrefetched: @escaping (Result<[Item], Error>) -> Void)
    
    /// Fetches the next page of items in the list.
    /// - Parameter onCompletion: A closure called upon completion with either a result containing an array of fetched items or an error.
    func getNextPage(_ onCompletion: @escaping (Result<[Item], Error>) -> Void)
    
    /// Resets the fetcher state, clearing any stored progress or cached data.
    func reset()
}

/// A specialized protocol for fetching a list of contact items.
/// - Note: This conforms to `ListFetcherProtocol` with `Item` being explicitly set to `ContactItem`.
public protocol ContactsListFetcherProtocol: ListFetcherProtocol where Item == ContactItem {}

/// A specialized protocol for fetching a list of image items.
/// - Note: This conforms to `ListFetcherProtocol` with `Item` being explicitly set to `ImageItem`.
public protocol ImagesListFetcherProtocol: ListFetcherProtocol where Item == ImageItem {}

/// A specialized protocol for fetching a list of video items.
/// - Note: This conforms to `ListFetcherProtocol` with `Item` being explicitly set to `VideoItem`.
public protocol VideosListFetcherProtocol: ListFetcherProtocol where Item == VideoItem {}
