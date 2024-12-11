//
//  DeviceProtocol.swift
//
//
//  Created by Vladica Pesic on 12/11/24.
//

import Foundation
import UIKit

public protocol DeviceProtocol {
    var identifierForVendor: UUID? { get }
    var systemName: String { get }
    var systemVersion: String { get }
}

extension UIDevice: DeviceProtocol {}
