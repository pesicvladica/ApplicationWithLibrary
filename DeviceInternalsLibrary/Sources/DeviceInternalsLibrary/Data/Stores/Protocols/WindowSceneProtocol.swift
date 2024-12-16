//
//  WindowSceneProtocol.swift
//
//
//  Created by Vladica Pesic on 12/11/24.
//

import Foundation
import UIKit

/// Protocol for accessing sceene properties.
public protocol WindowSceneProtocol {
    /// The windows in the window scene.
    var windows: [UIWindow] { get }
}

extension UIWindowScene: WindowSceneProtocol {}
