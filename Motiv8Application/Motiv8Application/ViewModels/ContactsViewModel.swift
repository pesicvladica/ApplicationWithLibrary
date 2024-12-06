//
//  ContactsViewModel.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation
import Motiv8Library

class ContactsViewModel: ListViewModelProtocol {
    
    // MARK: Private properties
    
    // The fetcher used to retrieve the contacts list.
    private let fetcher: any ContactsListFetcherProtocol
    
    // MARK: Public properties
    
    // The list of contacts.
    private(set) var listItems: [Any] = []
    // Closure called when data is fetched or an error occurs.
    var onDataFetched: ((Error?) -> Void)?
    
    // MARK: Initialization
    
    /// Initializes the ViewModel with a fetcher.
    ///
    /// - Parameter fetcher: The fetcher that retrieves the contacts list.
    init(fetcher: any ContactsListFetcherProtocol) {
        self.fetcher = fetcher
    }

    // MARK: Public methods
    
    // Fetches the next page of contacts.
    func fetchNextPage() {
        fetcher.getNextPage { [weak self] result in
            switch result {
            case .success(let fetchedContacts):
                self?.listItems.append(contentsOf: fetchedContacts)
                if fetchedContacts.count != 0 {
                    self?.onDataFetched?(nil)
                }
            case .failure(let error):
                self?.onDataFetched?(error)
            }
        }
    }
    
    // Resets the contacts list and fetches the first page.
    func resetAndFetch() {
        fetcher.reset()
        listItems.removeAll()
        fetchNextPage()
    }
}
