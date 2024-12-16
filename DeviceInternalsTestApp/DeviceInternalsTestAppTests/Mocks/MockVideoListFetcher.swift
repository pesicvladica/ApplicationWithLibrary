//
//  MockVideoListFetcher.swift
//  DeviceInternalsTestAppTests
//
//  Created by Vladica Pesic on 12/6/24.
//

import Foundation
import DeviceInternalsLibrary

// Mock for ContactsListFetcherProtocol
class MockVideoListFetcher: ListFetcher {
    typealias I = VideoItem
    
    var resultToReturn: Result<[VideoItem], Error>?
    
    func getItems(_ onCompletion: @escaping (Result<[VideoItem], Error>) -> Void) {
        if let result = resultToReturn {
            onCompletion(result)
        }
    }
    
    func getItems(at offset: Int, with limit: Int, _ onCompletion: @escaping (Result<[VideoItem], Error>) -> Void) {
        if let result = resultToReturn {
            onCompletion(result)
        }
    }
}
