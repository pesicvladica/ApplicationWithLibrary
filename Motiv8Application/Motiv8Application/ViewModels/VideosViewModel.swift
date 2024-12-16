//
//  VideosViewModel.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation
import DeviceInternalsLibrary

class VideosViewModel: ListViewModelProtocol {
    
    // MARK: Private properties
    
    // The fetcher used to retrieve the videos list.
    private let fetcher: any ListFetcher<VideoItem>
    
    // MARK: Public properties
    
    // The list of videos.
    private(set) var listItems: [Any] = []
    // Closure called when data is fetched or an error occurs.
    var onDataFetched: ((Error?) -> Void)?
    
    // MARK: Initialization
    
    /// Initializes the ViewModel with a fetcher.
    ///
    /// - Parameter fetcher: The fetcher that retrieves the videos list.
    init(fetcher: any ListFetcher<VideoItem>) {
        self.fetcher = fetcher
    }

    // MARK: Public methods
    
    // Fetches the next page of videos.
    func fetchNextPage() {
        fetcher.getItems(at: 0, with: 100) { [weak self] result in
            switch result {
            case .success(let fetchedVideos):
                self?.listItems.append(contentsOf: fetchedVideos)
                if fetchedVideos.count != 0 {
                    self?.onDataFetched?(nil)
                }
            case .failure(let error):
                self?.onDataFetched?(error)
            }
        }
    }
    
    // Resets the videos list and fetches the first page.
    func resetAndFetch() {
        listItems.removeAll()
        fetchNextPage()
    }
}
