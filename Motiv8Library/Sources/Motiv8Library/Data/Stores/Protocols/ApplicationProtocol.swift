//
//  File.swift
//  
//
//  Created by Vladica Pesic on 12/11/24.
//

import Foundation
import UIKit

/// Protocol for accessing application-level properties.
public protocol ApplicationProtocol {
    /// The connected scenes in the application.
    var connectedScenes: Set<UIScene> { get }
}

extension UIApplication: ApplicationProtocol {}
