//
//  MockVideoListFetcher.swift
//  Motiv8ApplicationTests
//
//  Created by Vladica Pesic on 12/6/24.
//

import Foundation
import Motiv8Library

// Mock for ContactsListFetcherProtocol
class MockVideoListFetcher: VideosListFetcherProtocol {
    
    var resultToReturn: Result<[VideoItem], Error>?
    var resetCalled = false
    
    func prefetchAllItems(_ onPrefetched: @escaping (Result<[VideoItem], Error>) -> Void) {
        if let result = resultToReturn {
            onPrefetched(result)
        }
    }
    
    func getNextPage(_ onCompletion: @escaping (Result<[VideoItem], Error>) -> Void) {
        if let result = resultToReturn {
            onCompletion(result)
        }
    }
    
    func reset() {
        resetCalled = true
    }
}
