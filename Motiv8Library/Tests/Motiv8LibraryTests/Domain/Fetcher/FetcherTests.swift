//
//  FetcherTests.swift
//
//
//  Created by Vladica Pesic on 12/5/24.
//

import XCTest
@testable import Motiv8Library

class FetcherTests: XCTestCase {
    
    var mockRegistry: MockRegistry!
    var sutItem: Fetcher<String>!
    var sutList: Fetcher<String>!
    
    override func setUp() {
        super.setUp()
        
        mockRegistry = MockRegistry()
        sutItem = Fetcher(registry: mockRegistry, storeType: MockStoreType.mockItemStore)
        sutList = Fetcher(registry: mockRegistry, storeType: MockStoreType.mockListStore)
    }
    
    override func tearDown() {
        mockRegistry = nil
        sutItem = nil
        sutList = nil
        super.tearDown()
    }
    
    func testFetcher_OnGetItem_WeakReferenceLost() {
        // Arrange
        weak var weakSut = sutItem
        
        let expectation = expectation(description: #function)
        
        // Act
        weakSut?.getItem({ result in
            
            switch result {
            case .success(let success):
                XCTFail("Should not be success when instance is deallocated \(success)")
            case .failure(let failure):
                
                // Assert
                XCTAssertNotNil(failure as? FetcherError, "Retrieved error should be of type FetcherError")
                XCTAssertEqual(failure as? FetcherError, FetcherError.custom(message: "Fetcher instance was deallocated"), "Error messages should have matched")
            }
            
            expectation.fulfill()
        })
        
        sutItem = Fetcher(registry: mockRegistry, storeType: MockStoreType.mockItemStore)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetcher_OnGetItem_FetchFailed() throws {
        // Arrange
        try mockRegistry.registerStores([MockStoreType.mockListStore])
        
        let expectation = expectation(description: #function)
        
        // Act
        sutItem.getItem({ result in
            
            switch result {
            case .success(let success):
                XCTFail("Should not be success when error is thrown \(success)")
            case .failure(let failure):
                
                // Assert
                XCTAssertNotNil(failure as? RegistryError, "Retrieved error should be of type RegistryError")
                XCTAssertEqual(failure as? RegistryError, RegistryError.storeNotFound, "Error messages should have matched")
            }
            
            expectation.fulfill()
        })
                
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetcher_OnGetItem_UnsupportedDataFailure() throws {
        // Arrange
        try mockRegistry.registerStores([MockStoreType.mockItemStore])

        let intFetcher = Fetcher<Int>(registry: mockRegistry, storeType: MockStoreType.mockItemStore)
        
        let expectation = expectation(description: #function)
        
        // Act
        intFetcher.getItem({ result in
            
            switch result {
            case .success(let success):
                XCTFail("Should not be success when error is thrown \(success)")
            case .failure(let failure):
                
                // Assert
                XCTAssertNotNil(failure as? FetcherError, "Retrieved error should be of type FetcherError")
                XCTAssertEqual(failure as? FetcherError, FetcherError.custom(message: "Unsupported data returned"), "Error messages should have matched")
            }
            
            expectation.fulfill()
        })
                
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetcher_OnGetItem_Success() throws {
        // Arrange
        try mockRegistry.registerStores([MockStoreType.mockItemStore])
        
        let expectation = expectation(description: #function)
        
        // Act
        sutItem.getItem({ result in
            
            switch result {
            case .success(let success):
                
                XCTAssertNotNil(success, "Should have retrieved value from registry")
                XCTAssertEqual(success, "Item", "Value should match mocked value")
            case .failure(let failure):
                
                // Assert
                XCTFail("Should not be failure when data is returned \(failure)")
            }
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetcher_OnGetItems_WeakReferenceLost() {
        // Arrange
        weak var weakSut = sutList
        
        let expectation = expectation(description: #function)
        
        // Act
        weakSut?.getItems(at: 0, with: 1) { result in
            
            switch result {
            case .success(let success):
                XCTFail("Should not be success when instance is deallocated \(success)")
            case .failure(let failure):
                
                // Assert
                XCTAssertNotNil(failure as? FetcherError, "Retrieved error should be of type FetcherError")
                XCTAssertEqual(failure as? FetcherError, FetcherError.custom(message: "Fetcher instance was deallocated"), "Error messages should have matched")
            }
            
            expectation.fulfill()
        }
        
        sutList = Fetcher(registry: mockRegistry, storeType: MockStoreType.mockListStore)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetcher_OnGetItems_FetchFailed() throws {
        // Arrange
        try mockRegistry.registerStores([MockStoreType.mockItemStore])
        
        let expectation = expectation(description: #function)
        
        // Act
        sutList.getItems(at: 0, with: 1) { result in
            
            switch result {
            case .success(let success):
                XCTFail("Should not be success when error is thrown \(success)")
            case .failure(let failure):
                
                // Assert
                XCTAssertNotNil(failure as? RegistryError, "Retrieved error should be of type RegistryError")
                XCTAssertEqual(failure as? RegistryError, RegistryError.storeNotFound, "Error messages should have matched")
            }
            
            expectation.fulfill()
        }
                
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetcher_OnGetItems_UnsupportedDataFailure() throws {
        // Arrange
        try mockRegistry.registerStores([MockStoreType.mockListStore])

        let intFetcher = Fetcher<Int>(registry: mockRegistry, storeType: MockStoreType.mockListStore)
        
        let expectation = expectation(description: #function)
        
        // Act
        intFetcher.getItems(at: 0, with: 1) { result in
            
            switch result {
            case .success(let success):
                XCTAssertNotNil(success, "Should have retrieved success from fetcher")
                XCTAssertEqual(success.count, 0, "Count should have been zero when there is type mismatch")
            case .failure(let failure):
                
                // Assert
                XCTFail("Should not throw error when empty list should be returned \(failure)")
            }
            
            expectation.fulfill()
        }
                
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetcher_OnGetItems_Success() throws {
        // Arrange
        try mockRegistry.registerStores([MockStoreType.mockListStore])
        
        let expectation = expectation(description: #function)
        
        // Act
        sutList.getItems(at: 0, with: 1) { result in
            
            switch result {
            case .success(let success):
                
                XCTAssertNotNil(success, "Should have retrieved values")
                XCTAssertEqual(success.count, 1, "Item count should be same as limit")
                XCTAssertEqual(success.first, "Item1", "Value should match mocked value")
            case .failure(let failure):
                
                // Assert
                XCTFail("Should not be failure when data is returned \(failure)")
            }
            
            expectation.fulfill()
        }
                
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetcher_OnGetAllItems_WeakReferenceLost() {
        // Arrange
        weak var weakSut = sutList
        
        let expectation = expectation(description: #function)
        
        // Act
        weakSut?.getItems { result in
            
            switch result {
            case .success(let success):
                XCTFail("Should not be success when instance is deallocated \(success)")
            case .failure(let failure):
                
                // Assert
                XCTAssertNotNil(failure as? FetcherError, "Retrieved error should be of type FetcherError")
                XCTAssertEqual(failure as? FetcherError, FetcherError.custom(message: "Fetcher instance was deallocated"), "Error messages should have matched")
            }
            
            expectation.fulfill()
        }
        
        sutList = Fetcher(registry: mockRegistry, storeType: MockStoreType.mockListStore)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetcher_OnGetAllItems_FetchFailed() throws {
        // Arrange
        try mockRegistry.registerStores([MockStoreType.mockItemStore])
        
        let expectation = expectation(description: #function)
        
        // Act
        sutList.getItems { result in
            
            switch result {
            case .success(let success):
                XCTFail("Should not be success when error is thrown \(success)")
            case .failure(let failure):
                
                // Assert
                XCTAssertNotNil(failure as? RegistryError, "Retrieved error should be of type RegistryError")
                XCTAssertEqual(failure as? RegistryError, RegistryError.storeNotFound, "Error messages should have matched")
            }
            
            expectation.fulfill()
        }
                
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetcher_OnGetAllItems_UnsupportedDataFailure() throws {
        // Arrange
        try mockRegistry.registerStores([MockStoreType.mockListStore])

        let intFetcher = Fetcher<Int>(registry: mockRegistry, storeType: MockStoreType.mockListStore)
        
        let expectation = expectation(description: #function)
        
        // Act
        intFetcher.getItems { result in
            
            switch result {
            case .success(let success):
                XCTAssertNotNil(success, "Should have retrieved success from fetcher")
                XCTAssertEqual(success.count, 0, "Count should have been zero when there is type mismatch")
            case .failure(let failure):
                
                // Assert
                XCTFail("Should not throw error when empty list should be returned \(failure)")
            }
            
            expectation.fulfill()
        }
                
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetcher_OnGetAllItems_Success() throws {
        // Arrange
        try mockRegistry.registerStores([MockStoreType.mockListStore])
        
        let expectation = expectation(description: #function)
        
        // Act
        sutList.getItems { result in
            
            switch result {
            case .success(let success):
                
                XCTAssertNotNil(success, "Should have retrieved values")
                XCTAssertEqual(success.count, 3, "Item count should be same as limit")
                XCTAssertEqual(success.first, "Item1", "Value should match mocked value")
                XCTAssertEqual(success.last, "Item3", "Value should match mocked value")
            case .failure(let failure):
                
                // Assert
                XCTFail("Should not be failure when data is returned \(failure)")
            }
            
            expectation.fulfill()
        }
                
        wait(for: [expectation], timeout: 1)
    }
}
