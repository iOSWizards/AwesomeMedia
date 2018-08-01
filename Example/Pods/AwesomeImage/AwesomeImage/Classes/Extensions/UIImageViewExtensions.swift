//
//  UIImageViewExtensions.swift
//  AwesomeImage
//
//  Created by Evandro Harrison Hoffmann on 4/13/18.
//

import UIKit
import AwesomeUIMagic
import Kingfisher

//private var loadedUrlAssociationKey: String = ""
//private var alreadyLoadedOriginalImageAssociationKey: Bool = false

extension UIImageView {
    
    /*final internal var loadedUrl: String! {
        get {
            return objc_getAssociatedObject(self, &loadedUrlAssociationKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &loadedUrlAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    final internal var alreadyLoadedOriginalImage: Bool! {
        get {
            return objc_getAssociatedObject(self, &alreadyLoadedOriginalImageAssociationKey) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &alreadyLoadedOriginalImageAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }*/
    
    public func setImage(_ urlString: String?, placeholder: UIImage? = nil, completion:((UIImage?) -> Void)? = nil) {
        self.layer.masksToBounds = true
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        self.startShimmerAnimation()
        kf.setImage(with: url, placeholder: placeholder) { (image, _, _, _) in
            self.stopShimmerAnimation()
            completion?(image)
        }
    }
        /*
         self.image = nil
         
        if let placeholder = placeholder {
            self.image = placeholder
        }
        
        self.loadedUrl = ""
        self.alreadyLoadedOriginalImage = false
        
        guard let url = url else {
            return
        }
        self.startShimmerAnimation()
        
        self.loadedUrl = url
        
        let initialLoadedUrl = self.loadedUrl as String
        
        if let thumbnailUrl = thumbnailUrl {
            _ = UIImage.loadImage(thumbnailUrl) { (image) in
                if(initialLoadedUrl == self.loadedUrl && !self.alreadyLoadedOriginalImage) {
                    self.image = image
                    if(animated) {
                        self.alpha = 0.2
                        UIView.animate(withDuration: 0.2, animations: {
                            self.alpha = 1.0
                        })
                    }
                } else {
                    return
                }
            }
        }
        
        UIImage.loadImage(url) { (image) in
            if(initialLoadedUrl == self.loadedUrl) {
                self.alreadyLoadedOriginalImage = true
                self.image = image
                if(animated) {
                    self.alpha = 0.2
                    UIView.animate(withDuration: 0.3, animations: {
                        self.alpha = 1.0
                    })
                }
                completion?(image)
            }
            self.stopShimmerAnimation()
        }
    }*/
    
}

