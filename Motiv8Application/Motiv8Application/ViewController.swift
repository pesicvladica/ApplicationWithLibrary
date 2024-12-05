//
//  ViewController.swift
//  Motiv8Application
//
//  Created by Vladica Pesic on 12/4/24.
//

import UIKit
import Motiv8Library

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.view.backgroundColor = .blue
        
        let lib = Motiv8Library.instance
        lib.fetchNextImagesPage { result in
            switch result {
            case .success(let items):
                debugPrint(items.count)
            case .failure(let failure):
                debugPrint(failure)
            }
        }
    }


}

