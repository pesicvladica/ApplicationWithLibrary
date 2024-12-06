//
//  ItemViewModelProtocol.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/5/24.
//

import Foundation

/// A protocol that defines the methods and properties for fetching and handling a single item.
///
/// This protocol is intended to be used by ViewModel classes that handle fetching a specific item
/// (such as device information, user data, etc.) and pass the result back to the view using a closure.
///
/// The protocol enables the ViewModel to notify the view controller when the item has been successfully
/// fetched or if an error occurs during the fetch operation.
protocol ItemViewModelProtocol {
    
    /// A closure that is called when the item fetch operation is complete.
    ///
    /// - The closure takes a `Result` type that can either be:
    ///   - `.success`: Contains the fetched item (of type `Any`, which should typically be a specific type like `DeviceItem`).
    ///   - `.failure`: Contains an `Error` object that represents any issue that occurred during the fetch operation.
    var onItemFetched: ((Result<Any, Error>) -> Void)? { get set }
    
    /// Initiates the fetch operation for the item.
    ///
    /// This method is called to start the fetch process, which will eventually trigger the `onItemFetched` closure
    /// with the result of the operation (either a success with the item or a failure with an error).
    func fetchItem()
}
