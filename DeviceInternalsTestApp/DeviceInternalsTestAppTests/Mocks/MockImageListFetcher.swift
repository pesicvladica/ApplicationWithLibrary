//
//  MockImageListFetcher.swift
//  DeviceInternalsTestAppTests
//
//  Created by Vladica Pesic on 12/6/24.
//

import Foundation
import DeviceInternalsLibrary

// Mock for ContactsListFetcherProtocol
class MockImageListFetcher: ListFetcher {
    typealias I = ImageItem
    
    var resultToReturn: Result<[ImageItem], Error>?
    
    func getItems(_ onCompletion: @escaping (Result<[ImageItem], Error>) -> Void) {
        if let result = resultToReturn {
            onCompletion(result)
        }
    }
    
    func getItems(at offset: Int, with limit: Int, _ onCompletion: @escaping (Result<[ImageItem], Error>) -> Void) {
        if let result = resultToReturn {
            onCompletion(result)
        }
    }
}
