//
//  GenericFetchingRepository.swift
//
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation

/// A generic repository for fetching data from multiple stores.
class GenericFetchingRepository: FetchingRepository {
    
    // MARK: Properties
    
    private let stores: [String: Any]
    
    // MARK: Initialization
    
    /// Initializes the repository with a dictionary of stores.
    ///
    /// - Parameters:
    ///    - stores: A dictionary where the key is a string representing the type of data (e.g., `"DeviceItem"`)
    ///              and the value is the corresponding `Store` instance responsible for fetching that type of data.
    init(stores: [String: Any]) {
        self.stores = stores
    }
    
    // MARK: FetchingRepository methods
    
    /// Fetches a list of data items of the specified type from the appropriate store.
    ///
    /// This method looks up the store corresponding to the provided type, and then calls the `fetchList` method
    /// on that store to retrieve the data. It handles any errors in case the store cannot be found.
    ///
    /// - Parameters:
    ///    - type: The type of data being fetched (used to find the appropriate store).
    ///    - offset: The starting point for pagination of the list.
    ///    - limit: The maximum number of items to fetch.
    ///    - onCompletion: A closure that is called with a result containing either the list of data items or an error.
    ///
    /// - Note: The store should conform to the `Store` protocol for this method to work.
    func fetchListData<T>(ofType type: T.Type, offset: Int, limit: Int, _ onCompletion: @escaping (Result<[T], Error>) -> Void) {
        guard let store = stores[String(describing: T.self)] as? Store<T> else {
            onCompletion(.failure(FetchingRepositoryError.invalidData))
            return
        }
        
        store.fetchList(offset: offset, limit: limit, onCompletion)
    }
    
    /// Fetches a single data item of the specified type from the appropriate store.
    ///
    /// This method looks up the store corresponding to the provided type and calls the `fetchItem` method on
    /// that store to retrieve the data item. It handles any errors in case the store cannot be found.
    ///
    /// - Parameters:
    ///    - type: The type of data being fetched (used to find the appropriate store).
    ///    - onCompletion: A closure that is called with a result containing either the data item or an error.
    ///
    /// - Note: The store should conform to the `Store` protocol for this method to work.
    func fetchItemData<T>(ofType type: T.Type, _ onCompletion: @escaping (Result<T, Error>) -> Void) {
        guard let store = stores[String(describing: T.self)] as? Store<T> else {
            onCompletion(.failure(FetchingRepositoryError.invalidData))
            return
        }
        
        store.fetchItem(onCompletion)
    }
}
