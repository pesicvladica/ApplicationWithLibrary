//
//  MockInfoItemFetcher.swift
//  Motiv8ApplicationTests
//
//  Created by Vladica Pesic on 12/6/24.
//

import Foundation
import DeviceInternalsLibrary

// Mock for InfoItemFetcherProtocol
class MockInfoItemFetcher: ItemFetcher {
    typealias I = DeviceItem
    

    var resultToReturn: Result<DeviceItem, Error>?
    
    func collect(_ onCompletion: @escaping (Result<DeviceItem, Error>) -> Void) {
        if let result = resultToReturn {
            onCompletion(result)
        }
    }
}
