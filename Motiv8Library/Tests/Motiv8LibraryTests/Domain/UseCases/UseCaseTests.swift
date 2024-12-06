//
//  File.swift
//  
//
//  Created by Vladica Pesic on 12/5/24.
//

import XCTest
@testable import Motiv8Library

class UseCaseTests: XCTestCase {
    
    var mockContactStore: MockStore<ContactItem>!
    var mockImageStore: MockStore<ImageItem>!
    var mockInfoStore: MockStore<DeviceItem>!
    var mockVideoStore: MockStore<VideoItem>!

    var mockRepository: GenericFetchingRepository!
    
    override func setUp() {
        super.setUp()
        // Initialize mock stores
        mockContactStore = MockStore<ContactItem>()
        mockImageStore = MockStore<ImageItem>()
        mockInfoStore = MockStore<DeviceItem>()
        mockVideoStore = MockStore<VideoItem>()

        // Initialize repository with mock stores
        mockRepository = GenericFetchingRepository(stores: [
            String(describing: ContactItem.self): mockContactStore as Any,
            String(describing: ImageItem.self): mockImageStore as Any,
            String(describing: DeviceItem.self): mockInfoStore as Any,
            String(describing: VideoItem.self): mockVideoStore as Any
        ])
    }

    override func tearDown() {
        mockContactStore = nil
        mockImageStore = nil
        mockInfoStore = nil
        mockVideoStore = nil
        
        mockRepository = nil
        super.tearDown()
    }

    func testContactFetcher_OnFetch_Success() {
        let mockFetcher = ContactFetcher(repository: mockRepository)
        let testContacts = [
            ContactItem(id: "1",
                        title: "Name Surname",
                        phoneNumbers: ["123456789"],
                        emails: ["mail@mail.com"]),
            ContactItem(id: "2",
                        title: "Name Surname",
                        phoneNumbers: ["987654321"],
                        emails: ["other@mail.com"])
        ]
        mockContactStore.fetchListResult = .success(testContacts)

        let expectation = self.expectation(description: #function)

        mockFetcher.getNextPage { result in
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, testContacts.count, "Item count should match")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testContactFetcher_OnFetch_Failure() {
        let mockFetcher = ContactFetcher(repository: mockRepository)
        mockContactStore.fetchListResult = .failure(FetchingRepositoryError.invalidData)

        let expectation = self.expectation(description: #function)

        mockFetcher.getNextPage { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error as? FetchingRepositoryError, FetchingRepositoryError.invalidData, "Should have received error invalid data")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testImageFetcher_OnFetch_Success() {
        let mockFetcher = ImageFetcher(repository: mockRepository)
        let testImages = [
            ImageItem(id: "1",
                      title: "image1",
                      dateCreated: Date(),
                      byteFileSize: 1024,
                      dimension: CGSize(width: 320, height: 320)),
            ImageItem(id: "2",
                      title: "image2",
                      dateCreated: Date(),
                      byteFileSize: 1024,
                      dimension: CGSize(width: 320, height: 320))
        ]
        mockImageStore.fetchListResult = .success(testImages)

        let expectation = self.expectation(description: #function)

        mockFetcher.getNextPage { result in
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, testImages.count, "Item count should match")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
    
    func testImageFetcher_OnFetch_Failure() {
        let mockFetcher = ImageFetcher(repository: mockRepository)
        mockImageStore.fetchListResult = .failure(FetchingRepositoryError.invalidData)

        let expectation = self.expectation(description: #function)

        mockFetcher.getNextPage { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error as? FetchingRepositoryError, FetchingRepositoryError.invalidData, "Should have received error invalid data")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testInfoFetcher_OnFetch_Success() {
        let mockFetcher = InfoFetcher(repository: mockRepository)
        let testDevice = DeviceItem(id: "1",
                                    title: "Phone",
                                    osVersion: "Test",
                                    manufacturer: "Apple",
                                    screenResolution: CGSize(width: 320, height: 320))
        mockInfoStore.fetchItemResult = .success(testDevice)
        
        let expectation = self.expectation(description: #function)
        
        mockFetcher.collect { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(item.id, testDevice.id, "Id should match")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testInfoFetcher_OnFetch_Failure() {
        let mockFetcher = InfoFetcher(repository: mockRepository)
        mockInfoStore.fetchItemResult = .failure(FetchingRepositoryError.invalidData)

        let expectation = self.expectation(description: #function)

        mockFetcher.collect { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error as? FetchingRepositoryError, FetchingRepositoryError.invalidData, "Should have received error invalid data")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testVideoFetcher_OnFetch_Success() {
        let mockFetcher = VideoFetcher(repository: mockRepository)
        let testVideos = [
            VideoItem(id: "1",
                      title: "image1",
                      dateCreated: Date(),
                      byteFileSize: 1024,
                      duration: 100),
            VideoItem(id: "2",
                      title: "image2",
                      dateCreated: Date(),
                      byteFileSize: 1024,
                      duration: 100)
        ]
        mockVideoStore.fetchListResult = .success(testVideos)

        let expectation = self.expectation(description: #function)

        mockFetcher.getNextPage { result in
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, testVideos.count, "Item count should match")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testVideoFetcher_OnFetch_Failure() {
        let mockFetcher = VideoFetcher(repository: mockRepository)
        mockVideoStore.fetchListResult = .failure(FetchingRepositoryError.invalidData)

        let expectation = self.expectation(description: #function)

        mockFetcher.getNextPage { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error as? FetchingRepositoryError, FetchingRepositoryError.invalidData, "Should have received error invalid data")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}

