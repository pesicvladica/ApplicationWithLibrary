//
//  VideosViewModelTests.swift
//  Motiv8ApplicationTests
//
//  Created by Vladica Pesic on 12/6/24.
//

import XCTest
import DeviceInternalsLibrary
@testable import Motiv8Application

final class VideosViewModelTests: XCTestCase {

    var mockFetcher: MockVideoListFetcher!
    var sut: VideosViewModel!
    
    override func setUp() {
        super.setUp()
        mockFetcher = MockVideoListFetcher()
        sut = VideosViewModel(fetcher: mockFetcher)
    }

    override func tearDown() {
        mockFetcher = nil
        sut = nil
        super.tearDown()
    }
    
    func testVideosViewModel_OnFetch_Success() {
        // Arrange
        var video1 = VideoItem()
        video1.test1()
        var video2 = VideoItem()
        video2.test2()
        mockFetcher.resultToReturn = .success([video1, video2])
        
        let expectation = self.expectation(description: #function)
        
        sut.onDataFetched = { error in
            // Assert
            XCTAssertNil(error)
            XCTAssertEqual(self.sut.listItems.count, 2)
            XCTAssertNotNil(self.sut.listItems.first as? VideoItem, "Items should be of type VideoItem")
            XCTAssertEqual((self.sut.listItems.first as? VideoItem)?.id, video1.id, "First item should have maching ids")
            XCTAssertEqual((self.sut.listItems.last as? VideoItem)?.id, video2.id, "Second item should have maching ids")
            expectation.fulfill()
        }
        
        // Act
        sut.fetchNextPage()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testVideosViewModel_OnFetch_Failure() {
        // Arrange
        let expectedError = NSError(domain: "com.yourapp.error", code: 1, userInfo: nil)
        mockFetcher.resultToReturn = .failure(expectedError)
        
        let expectation = self.expectation(description: #function)
        
        sut.onDataFetched = { error in
            // Assert
            XCTAssertNotNil(error, "Error should not be nil")
            XCTAssertEqual(error as? NSError, expectedError, "Errors should match")
            XCTAssertEqual(self.sut.listItems.count, 0, "Item count should be 0")
            expectation.fulfill()
        }
        
        // Act
        sut.fetchNextPage()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testVideosViewModel_OnReset_ResetIsCalled() {
        // Arrange
        mockFetcher.resetCalled = false
                
        // Act
        sut.resetAndFetch()
        
        // Assert
        XCTAssertTrue(mockFetcher.resetCalled, "Reset function should have been called")
    }
}

fileprivate extension VideoItem {
    mutating func test1() {
        id = "1"
        title = "Video 1"
        dateCreated = Date()
        byteFileSize = 1024
        duration = 60
    }
    
    mutating func test2() {
        id = "2"
        title = "Video 2"
        dateCreated = Date()
        byteFileSize = 2048
        duration = 120
    }
}
