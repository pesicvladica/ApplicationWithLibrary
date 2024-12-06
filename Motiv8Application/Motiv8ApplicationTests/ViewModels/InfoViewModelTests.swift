//
//  InfoViewModelTests.swift
//  Motiv8ApplicationTests
//
//  Created by Vladica Pesic on 12/6/24.
//

import XCTest
import Motiv8Library
@testable import Motiv8Application

final class InfoViewModelTests: XCTestCase {
    
    var mockFetcher: MockInfoItemFetcher!
    var sut: InfoViewModel!
    
    override func setUp() {
        super.setUp()
        mockFetcher = MockInfoItemFetcher()
        sut = InfoViewModel(fetcher: mockFetcher)
    }

    override func tearDown() {
        mockFetcher = nil
        sut = nil
        super.tearDown()
    }
        
    func testInfoViewModel_OnItemFetch_Success() {
        // Arrange
        var expectedItem = DeviceItem()
        expectedItem.test()
        
        mockFetcher.resultToReturn = .success(expectedItem)
        
        let expectation = self.expectation(description: #function)
        
        sut.onItemFetched = { result in
            // Assert
            switch result {
            case .success(let item):
                XCTAssertNotNil(item as? DeviceItem, "Fetched data should be of type DeviceItem")
                XCTAssertEqual((item as? DeviceItem)?.id, "12345678-1234-1234-1234-1234567890AB", "ID values should be same")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        // Act
        sut.fetchItem()
        
        wait(for: [expectation], timeout: 1)
    }
        
    func testInfoViewModel_OnItemFetch_Failure() {
        // Arrange
        let expectedError = NSError(domain: "com.yourapp.error", code: 1, userInfo: nil)
        mockFetcher.resultToReturn = .failure(expectedError)
        
        let expectation = self.expectation(description: #function)
        
        sut.onItemFetched = { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error as NSError, expectedError, "Should have received ")
            }
            
            expectation.fulfill()
        }
        
        // Act
        sut.fetchItem()
        
        wait(for: [expectation], timeout: 1)
    }
}

fileprivate extension DeviceItem {
    mutating func test() {
        id = "12345678-1234-1234-1234-1234567890AB"
        title = "iOS"
        osVersion = "14.1"
        manufacturer = "Apple"
        screenResolution = CGSize(width: 320, height: 320)
    }
}
