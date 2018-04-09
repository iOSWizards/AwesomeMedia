//
//  UISliderExtensions.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import UIKit

extension UISlider {
    
    public func setThumbImage(withImageName imageName: String = "btnSliderThumb") {
        setThumbImage(UIImage.image(imageName), for: .normal)
        setThumbImage(UIImage.image(imageName), for: .highlighted)
    }
}
