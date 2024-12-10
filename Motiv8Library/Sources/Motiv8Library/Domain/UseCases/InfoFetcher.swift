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
public final class InfoFetcher: UseCase, InfoItemFetcherProtocol {

    // MARK: Public methods
    
    /// Fetches device information from the repository.
    ///
    /// This method retrieves a single `DeviceItem` object, representing the details of the device.
    ///
    /// - Parameter onCompletion: A closure that gets called when the operation completes.
    ///   - Result<DeviceItem, Error>: Contains the fetched device information on success, or an error if the operation fails.
    public func collect(_ onCompletion: @escaping (Result<DeviceItem, Error>) -> Void) {
        Task {
            let info = try await self.repository.fetchItem(fromStoreForKey: StoreKey.deviceInfo)
            
            if let infoData = info as? DeviceItem {
                await MainActor.run {
                    onCompletion(.success(infoData))
                }
            }
            else {
                await MainActor.run {
                    onCompletion(.failure(UseCaseError.fetchFailed))
                }
            }
        }
    }
}
