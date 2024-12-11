//
//  ImagesViewModel.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation
import Motiv8Library

class ImagesViewModel: ListViewModelProtocol {
    
    // MARK: Private properties
    
    // The fetcher used to retrieve the images list.
    private let fetcher: any ListFetcher<ImageItem>
    
    // MARK: Public properties
    
    // The list of images.
    private(set) var listItems: [Any] = []
    // Closure called when data is fetched or an error occurs.
    var onDataFetched: ((Error?) -> Void)?
    
    // MARK: Initialization
    
    /// Initializes the ViewModel with a fetcher.
    ///
    /// - Parameter fetcher: The fetcher that retrieves the images list.
    init(fetcher: any ListFetcher<ImageItem>) {
        self.fetcher = fetcher
    }

    // MARK: Public methods
    
    // Fetches the next page of images.
    func fetchNextPage() {
        fetcher.getItems(at: 0, with: 100) { [weak self] result in
            switch result {
            case .success(let fetchedImages):
                self?.listItems.append(contentsOf: fetchedImages)
                if fetchedImages.count != 0 {
                    self?.onDataFetched?(nil)
                }
            case .failure(let error):
                self?.onDataFetched?(error)
            }
        }
    }
    
    // Resets the images list and fetches the first page.
    func resetAndFetch() {
        listItems.removeAll()
        fetchNextPage()
    }
}
