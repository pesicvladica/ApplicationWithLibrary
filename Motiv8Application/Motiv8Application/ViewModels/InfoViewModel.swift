//
//  InfoViewModel.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation
import Motiv8Library

class InfoViewModel: ItemViewModelProtocol {
    
    // MARK: Private properties
    
    // The fetcher used to get device information.
    private let fetcher: any InfoItemFetcherProtocol
    
    // MARK: Initialization
    
    /// Initializes the ViewModel with a fetcher.
    ///
    /// - Parameter fetcher: The fetcher that retrieves the device information.
    init(fetcher: any InfoItemFetcherProtocol) {
        self.fetcher = fetcher
    }
    
    // MARK: Public properties
    
    // Closure called when device information is fetched.
    var onItemFetched: ((Result<Any, Error>) -> Void)?

    // MARK: Public methods
    
    // Calls the fetcher's `collect` method and returns the result via `onItemFetched`.
    func fetchItem() {
        if let onCompletion = onItemFetched {
            fetcher.collect { result in
                switch result {
                case .success(let success):
                    onCompletion(.success(success))
                case .failure(let failure):
                    onCompletion(.failure(failure))
                }
            }
        }
    }
}
