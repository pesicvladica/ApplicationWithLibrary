//
//  InfoFetcher.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// A use case responsible for fetching device information using a repository.
///
/// `InfoFetcher` provides a simple method to collect detailed information about a device.
open class InfoFetcher: UseCase {

    // MARK: Public methods
    
    /// Fetches device information from the repository.
    ///
    /// This method retrieves a single `DeviceItem` object, representing the details of the device.
    ///
    /// - Parameter onCompletion: A closure that gets called when the operation completes.
    ///   - Result<DeviceItem, Error>: Contains the fetched device information on success, or an error if the operation fails.
    public func collectInfo(_ onCompletion: @escaping (Result<DeviceItem, Error>) -> Void) {
        repository.fetchItemData(ofType: DeviceItem.self, onCompletion)
    }
}
