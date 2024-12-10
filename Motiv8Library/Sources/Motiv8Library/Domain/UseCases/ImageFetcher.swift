//
//  ImageFetcher.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// A use case responsible for fetching image data in a paginated manner and providing options to prefetch all available images.
/// This class simplifies the interaction with a repository that supports fetching image data.
///
/// `ImageFetcher` maintains pagination state and provides methods for fetching individual pages or prefetching all images.
public final class ImageFetcher: UseCase, ImagesListFetcherProtocol {

    // MARK: Properties
    
    /// A list containing all images fetched so far during prefetching.
    private var fullImageList: [ImageItem] = []
    /// The current offset for paginated fetching, indicating where the next page of data begins.
    private var currentOffset: Int = 0
    /// The maximum number of images to fetch in a single operation. Defaults to 100.
    private var pageLimit: Int
    private var defaultPageLimit: Int
    
    // MARK: Initialization
    
    /// Initializes the `ImageFetcher` with a repository and an optional page limit for paginated data fetching.
    ///
    /// - Parameters:
    ///   - repository: A generic repository instance that provides access to image data.
    ///   - pageLimit: The maximum number of images to fetch per page. Defaults to 100.
    init(repository: FetchingRepository, pageLimit: Int = 100) {
        self.pageLimit = pageLimit
        self.defaultPageLimit = pageLimit
        super.init(repository: repository)
    }
    
    // MARK: Public methods
    
    /// Prefetches all available image data by repeatedly fetching pages until no more data is available.
    ///
    /// This method aggregates all fetched pages into a single list and provides the result through the completion handler.
    ///
    /// - Parameter onPrefetched: A closure that gets called when prefetching is complete.
    ///   - Result<[ImageItem], Error>: Contains the list of all fetched images on success, or an error if the operation fails.
    public func prefetchAllItems(_ onPrefetched: @escaping (Result<[ImageItem], Error>) -> Void) {
        pageLimit = 1000
        getNextPage { result in
            switch result {
            case .success(let success):
                self.fullImageList += success
                
                if success.count == self.pageLimit {
                    self.prefetchAllItems(onPrefetched)
                }
                else {
                    self.pageLimit = self.defaultPageLimit
                    onPrefetched(.success(self.fullImageList))
                }
            case .failure(_):
                self.reset()
                onPrefetched(.failure(UseCaseError.fetchFailed))
            }
        }
    }
    
    /// Fetches the next page of images from the repository.
    ///
    /// This method uses the current offset and page limit to retrieve a batch of image data.
    /// Updates the offset after each successful fetch.
    ///
    /// - Parameter onCompletion: A closure that gets called when the operation completes.
    ///   - Result<[ImageItem], Error>: Contains the fetched list of images on success, or an error if the operation fails.
    public func getNextPage(_ onCompletion: @escaping (Result<[ImageItem], Error>) -> Void) {
        Task.detached { [weak self] in
            guard let self else { return }
            
            do {
                let images = try await self.repository.fetchItems(fromStoreForKey: StoreKey.image, offset: self.currentOffset, limit: self.pageLimit)
                
                let mappedImages = images.compactMap({$0 as? ImageItem})
                await MainActor.run {
                    onCompletion(.success(mappedImages))
                }
            }
            catch (let error) {
                await MainActor.run {
                    onCompletion(.failure(error))
                }
            }

            self.currentOffset += self.pageLimit
        }
    }
    
    /// Resets the fetcher's state, clearing cached images and resetting the pagination offset.
    ///
    /// Call this method to start fetching images from the beginning or to clear previous prefetching results.
    public func reset() {
        pageLimit = defaultPageLimit
        currentOffset = 0
        fullImageList = []
    }
}
