//
//  MockWindowScene.swift
//  
//
//  Created by Vladica Pesic on 12/13/24.
//

import Foundation
import UIKit
@testable import DeviceInternalsLibrary

class MockWindowScene: WindowSceneProtocol {  
    
    private let size: CGSize = CGSize(width: 320, height: 480)
    private var window: UIWindow?
    
    init(withoutWindow: Bool) {
        if withoutWindow {
            window = nil
        }
        else {
            window = UIWindow(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        }
    }
    
    var windows: [UIWindow] {
        guard let activeWindow = window else {
            return []
        }
        return [activeWindow]
    }
}
