//
//  UIImageViewExtensions.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/13/18.
//

import UIKit

private var loadedUrlAssociationKey: String = ""
private var alreadyLoadedOriginalImageAssociationKey: Bool = false

public extension UIImageView {
    
    final internal var loadedUrl: String! {
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
    }
    
    public func setImage(_ url: String?, thumbnailUrl: String? = nil, placeholder: UIImage? = nil, animated: Bool = false, completion:((_ image: UIImage?) -> Void)? = nil) {
        self.layer.masksToBounds = true
        
        self.image = nil
        
        if let placeholder = placeholder {
            self.image = placeholder
        }
        
        self.loadedUrl = ""
        self.alreadyLoadedOriginalImage = false
        
        guard let url = url else {
            return
        }
        
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
        }
    }
    
}

// MARK: - UIImage Extension

extension UIImage {
    
    public static func loadImage(_ url: String?, completion:@escaping (_ image: UIImage?) -> Void) {
        if let url = url {
            let awesomeRequester = AwesomeMediaRequester()
            _ = awesomeRequester.performRequest(url, shouldCache: true, completion: { (data, errorData, responseType) in
                if let data = data {
                    completion(UIImage(data: data))
                } else {
                    completion(nil)
                }
            })
        }
    }
    
}

