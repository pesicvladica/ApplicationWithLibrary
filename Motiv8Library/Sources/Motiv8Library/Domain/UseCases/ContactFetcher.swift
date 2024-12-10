//
//  ContactFetcher.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// A use case responsible for fetching contact data in a paginated manner and providing options to prefetch all available contacts.
/// This class simplifies the interaction with a repository that supports fetching contact data.
///
/// `ContactFetcher` leverages a generic repository to handle data fetching operations while maintaining pagination state.
/// It provides an interface for fetching individual pages of contacts or prefetching all contacts in one operation.
public final class ContactFetcher: UseCase, ContactsListFetcherProtocol {
    
    // MARK: Properties
    
    /// A list containing all contacts fetched so far during prefetching.
    private var fullContactsList = [ContactItem]()
    /// The current offset for paginated fetching, tracking where the next page of data begins.
    private var currentOffset: Int = 0
    /// The maximum number of contacts to fetch in a single operation. Defaults to 100.
    private var pageLimit: Int
    
    // MARK: Initialization
    
    /// Initializes the `ContactFetcher` with a repository and an optional page limit for paginated data fetching.
    ///
    /// - Parameters:
    ///   - repository: A generic repository instance that provides access to contact data.
    ///   - pageLimit: The maximum number of contacts to fetch per page. Defaults to 100.
    init(repository: FetchingRepository, pageLimit: Int = 100) {
        self.pageLimit = pageLimit
        super.init(repository: repository)
    }
    
    // MARK: Public methods
    
    /// Prefetches all available contact data by repeatedly fetching pages until no more data is available.
    ///
    /// This method aggregates all fetched pages into a single list and provides the result through the completion handler.
    ///
    /// - Parameter onPrefetched: A closure that gets called when prefetching is complete.
    ///   - Result<[ContactItem], Error>: Contains the list of all fetched contacts on success, or an error if the operation fails.
    public func prefetchAllItems(_ onPrefetched: @escaping (Result<[ContactItem], Error>) -> Void) {
        self.getNextPage { result in
            switch result {
            case .success(let success):
                self.fullContactsList += success
                
                if success.count == self.pageLimit {
                    self.prefetchAllItems(onPrefetched)
                }
                else {
                    onPrefetched(.success(self.fullContactsList))
                }
            case .failure(_):
                self.reset()
                onPrefetched(.failure(UseCaseError.fetchFailed))
            }
        }
    }
    
    /// Fetches the next page of contacts from the repository.
    ///
    /// This method uses the current offset and page limit to retrieve a batch of contact data.
    /// Updates the offset after each successful fetch.
    ///
    /// - Parameter onCompletion: A closure that gets called when the operation completes.
    ///   - Result<[ContactItem], Error>: Contains the fetched list of contacts on success, or an error if the operation fails.
    public func getNextPage(_ onCompletion: @escaping (Result<[ContactItem], Error>) -> Void) {
        Task.detached { [weak self] in
            guard let self else { return }
            
            do {
                let contacts = try await self.repository.fetchItems(fromStoreForKey: StoreKey.contact, offset: self.currentOffset, limit: self.pageLimit)
                
                let mappedContacts = contacts.compactMap({$0 as? ContactItem})
                await MainActor.run {
                    onCompletion(.success(mappedContacts))
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
    
    /// Resets the fetcher's state, clearing cached contacts and resetting the pagination offset.
    ///
    /// Call this method to start fetching contacts from the beginning or to clear previous prefetching results.
    public func reset() {
        currentOffset = 0
        fullContactsList = []
    }
}
