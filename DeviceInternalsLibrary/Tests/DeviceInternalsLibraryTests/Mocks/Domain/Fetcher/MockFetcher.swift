//
//  MockFetcher.swift
//  
//
//  Created by Vladica Pesic on 12/13/24.
//

import Foundation
@testable import DeviceInternalsLibrary

public class MockFetcher<T>: ItemFetcher, ListFetcher {
    public typealias I = T
    
    var itemResponse: T?
    var listResponse: [T]?
    var fetcherError: FetcherError?
    
    public func getItem(_ onCompletion: @escaping (Result<T, Error>) -> Void) {
        if let error = fetcherError {
            onCompletion(.failure(error))
        }
    }
    
    public func getItems(_ onCompletion: @escaping (Result<[T], Error>) -> Void) {
        if let error = fetcherError {
            onCompletion(.failure(error))
        }
    }

    public func getItems(at offset: Int, with limit: Int, _ onCompletion: @escaping (Result<[T], Error>) -> Void) {
        if let error = fetcherError {
            onCompletion(.failure(error))
        }
    }
}
