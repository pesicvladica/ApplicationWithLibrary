//
//  Fetcher.swift
//  
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation

/// A generic fetcher for retrieving items or lists of items from a store.
/// - Note: This class supports fetching individual items, paginated lists, and recursive list fetching.
public class Fetcher<T>: ItemFetcher, ListFetcher {
    public typealias I = T
    
    // MARK: Properties
    
    private let storeType: any StoreType
    private let registry: StoreRegistry
    
    // MARK: Initialization
    
    /// Initializes a fetcher with the given registry and store type.
    ///
    /// - Parameters:
    ///   - registry: The store registry for fetching data.
    ///   - storeType: The type of store to fetch data from.
    ///
    init(registry: StoreRegistry, storeType: any StoreType) {
        self.storeType = storeType
        self.registry = registry
    }
    
    /// Fetches a single item from the associated store.
    ///
    /// - Parameters:
    ///   - onCompletion: A completion handler called with the result of the fetch operation.
    ///
    public func getItem(_ onCompletion: @escaping (Result<T, Error>) -> Void) {
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
    
    /// Fetches all items from the associated store using recursive pagination.
    ///
    /// - Parameters:
    ///   - onCompletion: A completion handler called with the result of the fetch operation.
    ///
    public func getItems(_ onCompletion: @escaping (Result<[T], Error>) -> Void) {
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
    
    /// Fetches a paginated list of items from the associated store.
    /// 
    /// - Parameters:
    ///   - offset: The starting index for the fetch.
    ///   - limit: The maximum number of items to fetch.
    ///   - onCompletion: A completion handler called with the result of the fetch operation.
    ///
    public func getItems(at offset: Int, with limit: Int, _ onCompletion: @escaping (Result<[T], Error>) -> Void) {
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
