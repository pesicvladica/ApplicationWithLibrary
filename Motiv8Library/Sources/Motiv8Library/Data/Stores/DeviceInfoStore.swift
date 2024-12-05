//
//  DeviceInfoStore.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import UIKit

/// A store for fetching information about the device.
class DeviceInfoStore: Store<DeviceItem> {

    // MARK: Properties
    
    private let device: UIDevice
    
    // MARK: Initialization
    
    /// Initializes a new `DeviceInfoStore` instance to fetch device information.
    ///
    /// - Parameters:
    ///    - device: An instance of `UIDevice` used to fetch the device information (defaults to `UIDevice.current`).
    init(device: UIDevice = UIDevice.current) {
        self.device = device
    }
    
    // MARK: Store<> methods
    
    /// Fetches information about the current device.
    ///
    /// This method gathers various details about the device, such as its identifier, system name, system version,
    /// screen resolution, and manufacturer. The information is then packaged into a `DeviceItem` object and returned
    /// via the completion handler.
    ///
    /// - Parameters:
    ///    - onCompletion: A closure that is called with a result containing either the `DeviceItem` with the device details or an error.
    ///
    /// - Note: This method retrieves data from `UIDevice` and `UIApplication` to generate the device information.
    override func fetchItem(_ onCompletion: @escaping (Result<DeviceItem, Error>) -> Void) {
        let identifierForVendor = device.identifierForVendor?.uuidString ?? "N/A"
        let systemName = device.systemName
        let systemVersion = device.systemVersion
        let screen = UIApplication.shared.connectedScenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene
        let screenSize = screen?.windows.first?.frame.size ?? UIScreen.main.bounds.size
        
        let deviceItem = DeviceItem(id: identifierForVendor,
                                    title: systemName,
                                    osVersion: systemVersion,
                                    manufacturer: "Apple",
                                    screenResolution: screenSize)

        onCompletion(.success(deviceItem))
    }
}
