//
//  StoreType.swift
//
//
//  Created by Vladica Pesic on 12/10/24.
//

import Foundation

/// Protocol representing a store type, which categorizes the kind of data the store provides.
public protocol StoreType: Hashable, CaseIterable {}

/// Enum defining the internal types of stores supported by the library.
public enum InternalType: StoreType {
    case contact
    case image
    case video
    case deviceInfo
}
