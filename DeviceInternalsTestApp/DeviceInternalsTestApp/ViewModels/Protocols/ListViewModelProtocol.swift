//
//  ListViewModelProtocol.swift
//  DeviceInternalsTestApp
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation

/// A protocol that defines the methods and properties for managing and fetching a list of items.
///
/// This protocol is intended to be implemented by ViewModel classes that manage a list of items (such as contacts, images, videos, etc.),
/// and handle the logic for fetching and updating the list, including pagination and resetting the data.
///
/// The protocol allows for notifying the view controller when data is fetched successfully or when an error occurs.
protocol ListViewModelProtocol {
    
    /// The list of items to be displayed in the view.
    ///
    /// This property contains the current set of items fetched by the ViewModel. The type is `Any` to allow flexibility, but it is
    /// expected that concrete implementations will use more specific types (such as `ContactItem`, `ImageItem`, `VideoItem`, etc.).
    var listItems: [Any] { get }
    
    /// A closure that is called when the data fetch operation is complete.
    ///
    /// The closure takes an optional `Error` parameter:
    /// - If `nil`, the data was fetched successfully.
    /// - If an error is passed, it means that an issue occurred during the fetch operation.
    var onDataFetched: ((Error?) -> Void)? { get set }
    
    /// Fetches the next page of data.
    ///
    /// This method is called when the user scrolls to the end of the list, triggering the need to load additional items for pagination.
    /// It will typically fetch the next set of items and append them to the current list of items.
    func fetchNextPage()
    
    /// Resets the data and initiates a new fetch.
    ///
    /// This method is used to clear the current list of items and fetch the data from the beginning (e.g., when a pull-to-refresh
    /// is triggered). It ensures that the list starts fresh before loading new data.
    func resetAndFetch()
}
