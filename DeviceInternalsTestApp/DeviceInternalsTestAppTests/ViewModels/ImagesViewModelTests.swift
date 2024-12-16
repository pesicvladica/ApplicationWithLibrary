//
//  ImagesViewModelTests.swift
//  DeviceInternalsTestAppTests
//
//  Created by Vladica Pesic on 12/6/24.
//

import XCTest
import DeviceInternalsLibrary
@testable import DeviceInternalsTestApp

final class ImagesViewModelTests: XCTestCase {

    var mockFetcher: MockImageListFetcher!
    var sut: ImagesViewModel!
    
    override func setUp() {
        super.setUp()
        mockFetcher = MockImageListFetcher()
        sut = ImagesViewModel(fetcher: mockFetcher)
    }

    override func tearDown() {
        mockFetcher = nil
        sut = nil
        super.tearDown()
    }
    
    func testImagesViewModel_OnFetch_Success() {
        // Arrange
        var image1 = ImageItem()
        image1.test1()
        var image2 = ImageItem()
        image2.test2()
        mockFetcher.resultToReturn = .success([image1, image2])
        
        let expectation = self.expectation(description: #function)
        
        sut.onDataFetched = { error in
            // Assert
            XCTAssertNil(error)
            XCTAssertEqual(self.sut.listItems.count, 2)
            XCTAssertNotNil(self.sut.listItems.first as? ImageItem, "Items should be of type ImageItem")
            XCTAssertEqual((self.sut.listItems.first as? ImageItem)?.id, image1.id, "First item should have maching IDs")
            XCTAssertEqual((self.sut.listItems.last as? ImageItem)?.id, image2.id, "Second item should have maching IDs")
            expectation.fulfill()
        }
        
        // Act
        sut.fetchNextPage()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testImagesViewModel_OnFetch_Failure() {
        // Arrange
        let expectedError = NSError(domain: "com.yourapp.error", code: 1, userInfo: nil)
        mockFetcher.resultToReturn = .failure(expectedError)
        
        let expectation = self.expectation(description: #function)
        
        sut.onDataFetched = { error in
            // Assert
            XCTAssertNotNil(error, "Error should not be Nil")
            XCTAssertEqual(error as? NSError, expectedError)
            XCTAssertEqual(self.sut.listItems.count, 0, "Item Count should be 0")
            expectation.fulfill()
        }
        
        // Act
        sut.fetchNextPage()
        
        wait(for: [expectation], timeout: 1)
    }
}

fileprivate extension ImageItem {
    mutating func test1() {
        id = "1"
        title = "Image 1"
        dateCreated = Date()
        byteFileSize = 1024
        dimension = CGSize(width: 320.0, height: 320.0)
    }
    
    mutating func test2() {
        id = "2"
        title = "Image 2"
        dateCreated = Date()
        byteFileSize = 2048
        dimension = CGSize(width: 320.0, height: 320.0)
    }
}
