//
//  ContactsViewModelTests.swift
//  Motiv8ApplicationTests
//
//  Created by Vladica Pesic on 12/6/24.
//

import XCTest
import Motiv8Library
@testable import Motiv8Application

final class ContactsViewModelTests: XCTestCase {

    var mockFetcher: MockContactsListFetcher!
    var sut: ContactsViewModel!
    
    override func setUp() {
        super.setUp()
        mockFetcher = MockContactsListFetcher()
        sut = ContactsViewModel(fetcher: mockFetcher)
    }

    override func tearDown() {
        mockFetcher = nil
        sut = nil
        super.tearDown()
    }
    
    func testContactsViewModel_OnFetch_Success() {
        // Arrange
        var contact1 = ContactItem()
        contact1.test1()
        var contact2 = ContactItem()
        contact2.test2()
        mockFetcher.resultToReturn = .success([contact1, contact2])
        
        let expectation = self.expectation(description: #function)
        
        sut.onDataFetched = { error in
            // Assert
            XCTAssertNil(error)
            XCTAssertEqual(self.sut.listItems.count, 2)
            XCTAssertNotNil(self.sut.listItems.first as? ContactItem, "Items should be of type ContactItem")
            XCTAssertEqual((self.sut.listItems.first as? ContactItem)?.id, contact1.id, "First item should have maching IDs")
            XCTAssertEqual((self.sut.listItems.last as? ContactItem)?.id, contact2.id, "Second item should have maching IDs")
            expectation.fulfill()
        }
        
        // Act
        sut.fetchNextPage()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testContactsViewModel_OnFetch_Failure() {
        // Arrange
        let expectedError = NSError(domain: "com.yourapp.error", code: 1, userInfo: nil)
        mockFetcher.resultToReturn = .failure(expectedError)
        
        let expectation = self.expectation(description: #function)
        
        sut.onDataFetched = { error in
            // Assert
            XCTAssertNotNil(error)
            XCTAssertEqual(error as? NSError, expectedError)
            XCTAssertEqual(self.sut.listItems.count, 0)
            expectation.fulfill()
        }
        
        // Act
        sut.fetchNextPage()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testContactsViewModel_OnReset_ResetIsCalled() {
        // Arrange
        mockFetcher.resetCalled = false
                
        // Act
        sut.resetAndFetch()
        
        // Assert
        XCTAssertTrue(mockFetcher.resetCalled, "Reset function should have been called")
    }
}

fileprivate extension ContactItem {
    mutating func test1() {
        id = "1"
        title = "First Name 1"
        phoneNumbers = ["number1", "number2"]
        emails = ["email1", "email2"]
    }
    
    mutating func test2() {
        id = "2"
        title = "First Name 2"
        phoneNumbers = ["number3", "number4"]
        emails = ["email3", "email4"]
    }
}
