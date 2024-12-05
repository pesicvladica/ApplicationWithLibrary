//
//  GenericFetchingRepositoryTests.swift
//
//
//  Created by Vladica Pesic on 12/5/24.
//

import XCTest
@testable import Motiv8Library

class GenericFetchingRepositoryTests: XCTestCase {

    var mockStore: MockStore<TestData>!
    var sut: GenericFetchingRepository!
    
    override func setUp() {
        super.setUp()

        // Initialize mock store
        mockStore = MockStore<TestData>()

        // Initialize repository with mock store
        sut = GenericFetchingRepository(stores: [
            String(describing: TestData.self): mockStore as Any
        ])
    }

    override func tearDown() {
        mockStore = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testGenericFetchingRepository_OnFetchListData_Success() {
        // Arrange
        let testDataList = [
            TestData(id: "1", title: "Item 1"),
            TestData(id: "2", title: "Item 2")
        ]
        mockStore.fetchListResult = .success(testDataList)

        let expectation = self.expectation(description: #function)

        // Act
        sut.fetchListData(ofType: TestData.self, offset: 0, limit: 10) { result in
            // Assert
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, testDataList.count, "Item count should be same")
                XCTAssertEqual(items.first?.title, testDataList.first?.title, "First item title should match in provided objet and fetched object")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testGenericFetchingRepository_OnFetchListData_Failure() {
        // Arrange
        mockStore.fetchListResult = .failure(FetchingRepositoryError.invalidData)

        let expectation = self.expectation(description: #function)

        // Act
        sut.fetchListData(ofType: TestData.self, offset: 0, limit: 10) { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error as? FetchingRepositoryError, FetchingRepositoryError.invalidData, "Received error should be Fetching repository error invalid data")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testGenericFetchingRepository_OnFetchItemData_Success() {
        // Arrange
        let testData = TestData(id: "1", title: "Item 1")
        mockStore.fetchItemResult = .success(testData)

        let expectation = self.expectation(description: #function)

        // Act
        sut.fetchItemData(ofType: TestData.self) { result in
            // Assert
            switch result {
            case .success(let item):
                XCTAssertEqual(item.title, testData.title, "Provided title should match with fetched data title")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testGenericFetchingRepository_OnFetchItemData_Failure() {
        // Arrange
        mockStore.fetchItemResult = .failure(FetchingRepositoryError.invalidData)

        let expectation = self.expectation(description: #function)

        // Act
        sut.fetchItemData(ofType: TestData.self) { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error as? FetchingRepositoryError, FetchingRepositoryError.invalidData, "Received error should be Fatching repository error invalid data")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testGenericFetchingRepository_OnFetchListData_InvalidStore() {
        // Arrange
        let expectation = self.expectation(description: #function)

        // Act
        sut.fetchListData(ofType: String.self, offset: 0, limit: 10) { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error as? FetchingRepositoryError, FetchingRepositoryError.invalidData, "Received error should be Fatching repository error invalid data")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testGenericFetchingRepository_OnFetchItemData_InvalidStore() {
        // Arrange
        let expectation = self.expectation(description: #function)

        // Act
        sut.fetchItemData(ofType: String.self) { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error as? FetchingRepositoryError, FetchingRepositoryError.invalidData, "Received error should be Fatching repository error invalid data")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
