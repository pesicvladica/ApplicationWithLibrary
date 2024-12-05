//
//  File.swift
//  
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation
@testable import Motiv8Library

class MockStore<T>: Store<T> where T: Item {

    var fetchListResult: Result<[T], Error>?
    var fetchItemResult: Result<T, Error>?

    override func fetchList(offset: Int, limit: Int, _ onCompletion: @escaping (Result<[T], Error>) -> Void) {
        if let result = fetchListResult {
            onCompletion(result)
        }
    }

    override func fetchItem(_ onCompletion: @escaping (Result<T, Error>) -> Void) {
        if let result = fetchItemResult {
            onCompletion(result)
        }
    }
}

struct TestData: Item {
    var id: String
    var title: String
}
