//
//  File.swift
//  
//
//  Created by Vladica Pesic on 12/11/24.
//

import Foundation
import UIKit

public protocol ApplicationProtocol {
    var connectedScenes: Set<UIScene> { get }
}

extension UIApplication: ApplicationProtocol {}
