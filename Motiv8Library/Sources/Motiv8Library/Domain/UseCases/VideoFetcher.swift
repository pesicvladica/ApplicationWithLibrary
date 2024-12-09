//
//  VideoFetcher.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// A use case responsible for fetching video data in a paginated manner and providing options to prefetch all available videos.
/// This class simplifies interactions with a repository that supports fetching video data.
///
/// `VideoFetcher` maintains pagination state and provides methods for fetching individual pages or prefetching all videos.
public final class VideoFetcher: UseCase, VideosListFetcherProtocol {

    // MARK: Properties
    
    /// A list containing all videos fetched so far during prefetching.
    private var fullVideoList: [VideoItem] = []
    /// The current offset for paginated fetching, indicating where the next page of data begins.
    private var currentOffset: Int = 0
    /// The maximum number of videos to fetch in a single operation. Defaults to 100.
    private var pageLimit: Int
    private var defaultPageLimit: Int
    
    // MARK: Initialization
    
    /// Initializes the `VideoFetcher` with a repository and an optional page limit for paginated data fetching.
    ///
    /// - Parameters:
    ///   - repository: A generic repository instance that provides access to video data.
    ///   - pageLimit: The maximum number of videos to fetch per page. Defaults to 100.
    init(repository: FetchingRepository, pageLimit: Int = 100) {
        self.pageLimit = pageLimit
        self.defaultPageLimit = pageLimit
        super.init(repository: repository)
    }
    
    // MARK: Public methods
    
    /// Prefetches all available video data by repeatedly fetching pages until no more data is available.
    ///
    /// This method aggregates all fetched pages into a single list and provides the result through the completion handler.
    ///
    /// - Parameter onPrefetched: A closure that gets called when prefetching is complete.
    ///   - Result<[VideoItem], Error>: Contains the list of all fetched videos on success, or an error if the operation fails.
    public func prefetchAllItems(_ onPrefetched: @escaping (Result<[VideoItem], Error>) -> Void) {
        pageLimit = 1000
        getNextPage { result in
            switch result {
            case .success(let success):
                self.fullVideoList += success
                
                if success.count == self.pageLimit {
                    self.prefetchAllItems(onPrefetched)
                }
                else {
                    self.pageLimit = self.defaultPageLimit
                    onPrefetched(.success(self.fullVideoList))
                }
            case .failure(_):
                self.reset()
                onPrefetched(.failure(UseCaseError.fetchFailed))
            }
        }
    }
    
    /// Fetches the next page of videos from the repository.
    ///
    /// This method uses the current offset and page limit to retrieve a batch of video data.
    /// Updates the offset after each successful fetch.
    ///
    /// - Parameter onCompletion: A closure that gets called when the operation completes.
    ///   - Result<[VideoItem], Error>: Contains the fetched list of videos on success, or an error if the operation fails.
    public func getNextPage(_ onCompletion: @escaping (Result<[VideoItem], Error>) -> Void) {
        Task.detached { [weak self] in
            guard let self else { return }
            
            self.repository.fetchListData(ofType: VideoItem.self, offset: self.currentOffset, limit: self.pageLimit) { result in
                Task {
                    await MainActor.run {
                        onCompletion(result)
                    }
                }
            }
            self.currentOffset += self.pageLimit
        }
    }
    
    /// Resets the fetcher's state, clearing cached videos and resetting the pagination offset.
    ///
    /// Call this method to start fetching videos from the beginning or to clear previous prefetching results.
    public func reset() {
        pageLimit = defaultPageLimit
        currentOffset = 0
        fullVideoList = []
    }
}
