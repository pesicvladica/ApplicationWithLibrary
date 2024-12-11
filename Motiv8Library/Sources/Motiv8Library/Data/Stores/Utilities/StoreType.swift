//
//  StoreType.swift
//
//
//  Created by Vladica Pesic on 12/10/24.
//

import Foundation

public enum StoreType: Hashable, CaseIterable {
    case contact
    case image
    case video
    case deviceInfo
    
    public enum StoreProvider {
        case item
        case list
        case stream
    }
    
    func isProviding() -> StoreProvider {
        switch self {
        case .contact, .image, .video:
            return .list
        case .deviceInfo:
            return .item
        }
    }
}
