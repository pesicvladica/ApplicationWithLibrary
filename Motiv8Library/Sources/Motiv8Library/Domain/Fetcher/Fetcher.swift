//
//  File.swift
//  
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation

/// Base class for use cases interacting with repositories.
public class Fetcher<T>: ItemFetcher, ListFetcher {
    public typealias I = T
    
    // MARK: Properties
    
    private let storeType: StoreType
    
    public let registry: StoreRegistry
    
    // MARK: Initialization
    
    /// Initializes the use case with a specified repository.
    ///
    /// This initializer sets up the `UseCase` with a repository that handles data fetching. The repository is used
    /// by the use case to fetch the required data from various stores. The use case can be expanded to include business
    /// logic or other operations in addition to data retrieval.
    ///
    /// - Parameter repository: The repository responsible for fetching data.
    init(registry: StoreRegistry, storeType: StoreType) {
        self.storeType = storeType
        self.registry = registry
    }
    
    public func getItem(_ onCompletion: @escaping (Result<T, Error>) -> Void) {
        if storeType.isProviding() != .item {
            onCompletion(.failure(FetcherError.custom(message: "Fetcher does not implement single item fetching")))
            return
        }
        
        Task.detached { [weak self] in
            guard let self = self else {
                await MainActor.run {
                    onCompletion(.failure(FetcherError.custom(message: "Fetcher instance was deallocated")))
                }
                return
            }
            
            do {
                if let item = try await self.registry.item(fromStoreForKey: self.storeType) as? T {
                    await MainActor.run {
                        onCompletion(.success(item))
                    }
                }
                else {
                    await MainActor.run {
                        onCompletion(.failure(FetcherError.custom(message: "Unsupported data returned")))
                    }
                }
            }
            catch {
                await MainActor.run {
                    onCompletion(.failure(error))
                }
            }
        }
    }
    
    public func getItems(_ onCompletion: @escaping (Result<[T], Error>) -> Void) {
        if storeType.isProviding() != .list {
            onCompletion(.failure(FetcherError.custom(message: "Fetcher does not implement list fetching")))
            return
        }
        
        Task.detached { [weak self] in
            guard let self = self else {
                await MainActor.run {
                    onCompletion(.failure(FetcherError.custom(message: "Fetcher instance was deallocated")))
                }
                return
            }
            
            var accumulatedItems: [T] = []
            let prefatchPageLimit = 300
            var currentOffset = 0
            
            func fetchNextBatch() async {
                
                do {
                    let items = try await self.registry.items(fromStoreForKey: self.storeType,
                                                              offset: currentOffset,
                                                              limit: prefatchPageLimit)
                    
                    let mappedItems = items.compactMap { $0 as? T }
                    accumulatedItems.append(contentsOf: mappedItems)
                    
                    if mappedItems.count == prefatchPageLimit {
                        currentOffset += prefatchPageLimit
                        await fetchNextBatch() // Fetch the next batch recursively
                    } else {
                        onCompletion(.success(accumulatedItems)) // All items fetched
                    }
                }
                catch {
                    onCompletion(.failure(error)) // Handle errors
                }
            }
            
            await fetchNextBatch()
        }
    }
    
    public func getItems(at offset: Int, with limit: Int, _ onCompletion: @escaping (Result<[T], Error>) -> Void) {
        if storeType.isProviding() != .list {
            onCompletion(.failure(FetcherError.custom(message: "Fetcher does not implement list fetching")))
            return
        }
        
        Task.detached { [weak self] in
            guard let self = self else {
                await MainActor.run {
                    onCompletion(.failure(FetcherError.custom(message: "Fetcher instance was deallocated")))
                }
                return
            }
            
            do {
                let items = try await self.registry.items(fromStoreForKey: self.storeType, offset: offset, limit: limit)
                
                let mappedItems = items.compactMap { $0 as? T }
                await MainActor.run {
                    onCompletion(.success(mappedItems))
                }
            }
            catch {
                await MainActor.run {
                    onCompletion(.failure(error))
                }
            }
        }
    }
}
