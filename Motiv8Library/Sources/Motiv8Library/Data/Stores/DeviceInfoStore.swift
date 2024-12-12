//
//  DeviceInfoStore.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import UIKit

/// A store for fetching information about the device.
class DeviceInfoStore: ItemStore {

    // MARK: Properties
    
    private(set) var storeKey: any StoreType
    
    private let device: DeviceProtocol
    private let application: ApplicationProtocol
    
    // MARK: Initialization
    
    /// Initializes a new `DeviceInfoStore` instance to fetch device information.
    ///
    /// - Parameters:
    ///    - device: An instance of `DeviceProtocol` used to fetch the device information.
    ///    - application: An instance of `ApplicationProtocol` used to fetch the screen information.
    ///
    init(device: DeviceProtocol, application: ApplicationProtocol) {
        
        self.storeKey = InternalType.deviceInfo
        self.device = device
        self.application = application
    }
    
    // MARK: Store methods
    
    /// Fetches information about the current device.
    ///
    /// This method gathers various details about the device, such as its identifier, system name, system version,
    /// screen resolution, and manufacturer. The information is then packaged into a `DeviceItem` object and returned
    ///
    /// - Returns:
    ///    - DeviceItem object containg device specific data
    func fetchItem() async throws -> Any  {
        let identifierForVendor = device.identifierForVendor?.uuidString ?? "N/A"
        let systemName = device.systemName
        let systemVersion = device.systemVersion
        let screen = application.connectedScenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene
        let screenSize = await screen?.windows.first?.frame.size ?? CGSize.zero
        
        let deviceItem = DeviceItem(id: identifierForVendor,
                                    title: systemName,
                                    osVersion: systemVersion,
                                    manufacturer: "Apple",
                                    screenResolution: screenSize)

        return deviceItem
    }
}
