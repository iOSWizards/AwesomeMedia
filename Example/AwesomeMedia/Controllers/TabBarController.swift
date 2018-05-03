//
//  TabBarController.swift
//  AwesomeMedia_Example
//
//  Created by Evandro Harrison Hoffmann on 5/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // set default orientation
        awesomeMediaOrientation = .portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return awesomeMediaOrientation
    }

}
