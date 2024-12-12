//
//  Permission.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// Protocol for managing permission requests. Each class conforming to this protocol must implement the `requestPermission` method to handle permission requests.
public protocol Permission {
    /// Requests permission asynchronously.
    func requestPermission() async throws
}
