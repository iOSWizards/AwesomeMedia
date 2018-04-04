//
//  DesignableNavigationBar.swift
//  MVUIHacks
//
//  Created by Evandro Harrison Hoffmann on 03/08/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

@IBDesignable
open class DesignableNavigationBar: UINavigationBar {

    @IBInspectable open var isTransparentBackground: Bool = false {
        didSet {
            if isTransparentBackground {
                self.setBackgroundImage(UIImage(), for: .default)
                self.shadowImage = UIImage()
            }
        }
    }

}
