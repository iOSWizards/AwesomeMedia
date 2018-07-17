//
//  UIButton+Awesome.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 6/7/16.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit
import AwesomeLoading
import Kingfisher

extension UIButton{
    
    public func setImage(_ urlString: String?, placeholder: UIImage? = nil, state: UIControlState, completion:((UIImage?) -> Void)?) {
        self.layer.masksToBounds = true
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        self.startShimmerAnimation()
        kf.setImage(with: url, for: state, placeholder: placeholder) { (image, _, _, _) in
            self.stopShimmerAnimation()
            completion?(image)
        }
        
        /*if let placeholder = placeholder {
            self.setImage(placeholder, for: state)
        }
        
        self.startShimmerAnimation()
        UIImage.loadImage(url) { (image) in
            self.stopShimmerAnimation()
            self.setImage(image, for: state)
            completion?(image)
        }*/
    }
    
}
