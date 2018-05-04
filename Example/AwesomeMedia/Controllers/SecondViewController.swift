//
//  SecondViewController.swift
//  AwesomeMedia_Example
//
//  Created by Evandro Harrison Hoffmann on 5/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class SecondViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        awesomeMediaOrientation = .portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
