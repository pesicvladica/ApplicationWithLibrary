//
//  MockInfoItemFetcher.swift
//  Motiv8ApplicationTests
//
//  Created by Vladica Pesic on 12/6/24.
//

import Foundation
import Motiv8Library

// Mock for InfoItemFetcherProtocol
class MockInfoItemFetcher: InfoItemFetcherProtocol {

    var resultToReturn: Result<DeviceItem, Error>?
    
    func collect(_ onCompletion: @escaping (Result<DeviceItem, Error>) -> Void) {
        if let result = resultToReturn {
            onCompletion(result)
        }
    }
}
