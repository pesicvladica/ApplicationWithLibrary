//
//  DeviceProtocol.swift
//
//
//  Created by Vladica Pesic on 12/11/24.
//

import Foundation
import UIKit

/// Protocol for accessing device-specific information.
public protocol DeviceProtocol {
    /// The unique identifier for the device.
    var identifierForVendor: UUID? { get }
    /// The name of the operating system.
    var systemName: String { get }
    /// The version of the operating system.
    var systemVersion: String { get }
}

extension UIDevice: DeviceProtocol {}
