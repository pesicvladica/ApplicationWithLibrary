//
//  DeviceItem.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// A model representing a device with specifications like OS version and screen resolution.
public struct DeviceItem: Item {
    public var id: String
    public var title: String

    public var osVersion: String
    public var manufacturer: String
    public var screenResolution: CGSize
}
