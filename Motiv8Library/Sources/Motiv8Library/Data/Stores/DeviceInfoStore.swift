//
//  DeviceInfoStore.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import UIKit

/// A store for fetching information about the device.
class DeviceInfoStore: Store {
    typealias Item = DeviceItem

    // MARK: Properties
    
    private(set) var storeKey: StoreKey
    
    private let device: UIDevice
    
    // MARK: Initialization
    
    /// Initializes a new `DeviceInfoStore` instance to fetch device information.
    ///
    /// - Parameters:
    ///    - device: An instance of `UIDevice` used to fetch the device information (defaults to `UIDevice.current`).
    init(device: UIDevice = UIDevice.current) {
        
        self.storeKey = StoreKey.deviceInfo
        self.device = device
    }
    
    // MARK: Store<> methods
    
    /// Fetches information about the current device.
    ///
    /// This method gathers various details about the device, such as its identifier, system name, system version,
    /// screen resolution, and manufacturer. The information is then packaged into a `DeviceItem` object and returned
    ///
    /// - Returns:
    ///    - DeviceItem object containg device specific data
    ///
    /// - Note: This method retrieves data from `UIDevice` and `UIApplication` to generate the device information.
    func fetchItem() async throws -> DeviceItem  {
        let identifierForVendor = await device.identifierForVendor?.uuidString ?? "N/A"
        let systemName = await device.systemName
        let systemVersion = await device.systemVersion
        let screen = await UIApplication.shared.connectedScenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene
        let screenSize = await screen?.windows.first?.frame.size ?? CGSize.zero
        
        let deviceItem = DeviceItem(id: identifierForVendor,
                                    title: systemName,
                                    osVersion: systemVersion,
                                    manufacturer: "Apple",
                                    screenResolution: screenSize)

        return deviceItem
    }
    
    // MARK: Unsupported methods
    
    func fetchList(offset: Int, limit: Int) async throws -> [DeviceItem] {
        throw StoreError.methodNotSupported("\(type(of: self))", #function)
    }
    
    func stream() -> AsyncThrowingStream<DeviceItem, Error> {
        AsyncThrowingStream {
            throw StoreError.methodNotSupported("\(type(of: self))", #function)
        }
    }
}
