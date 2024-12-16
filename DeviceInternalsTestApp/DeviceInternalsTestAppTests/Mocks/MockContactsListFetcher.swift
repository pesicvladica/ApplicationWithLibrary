//
//  MockContactsListFetcher.swift
//  DeviceInternalsTestAppTests
//
//  Created by Vladica Pesic on 12/6/24.
//

import Foundation
import DeviceInternalsLibrary

// Mock for ContactsListFetcherProtocol
class MockContactsListFetcher: ListFetcher {
    typealias I = ContactItem
    
    var resultToReturn: Result<[ContactItem], Error>?
    
    func getItems(_ onCompletion: @escaping (Result<[ContactItem], Error>) -> Void) {
        if let result = resultToReturn {
            onCompletion(result)
        }
    }
    
    func getItems(at offset: Int, with limit: Int, _ onCompletion: @escaping (Result<[ContactItem], Error>) -> Void) {
        if let result = resultToReturn {
            onCompletion(result)
        }
    }
}
