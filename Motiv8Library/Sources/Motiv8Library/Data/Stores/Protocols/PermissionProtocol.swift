//
//  PermissionProtocol.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// Protocol for managing permission requests. Each class conforming to this protocol must implement the `requestPermission` method to handle permission requests.
protocol PermissionProtocol {
    /// Requests permission for a resource and calls the completion handler with the result.
    /// - Parameter completion: A closure that returns either a success or failure result.
    func requestPermission(completion: @escaping (Result<Void, Error>) -> Void)
}
