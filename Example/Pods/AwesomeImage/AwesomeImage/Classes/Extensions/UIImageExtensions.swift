//
//  UIImageExtensions.swift
//  AwesomeImage
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import Foundation
import AwesomeUIMagic
import Kingfisher

extension UIImage {
    
    public static func image(_ named: String) -> UIImage? {
        return UIImage(named: named, in: AwesomeImage.bundle, compatibleWith: nil)
    }

    public static func loadImage(_ urlString: String?, completion:@escaping (_ image: UIImage?) -> Void) {
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
            (image, _, _, _) in
            completion(image)
        }
        
        /*if let url = url {
            let awesomeRequester = AwesomeImageRequester()
            _ = awesomeRequester.performRequest(url, shouldCache: true, completion: { (data, errorData, responseType) in
                DispatchQueue.main.async {
                    if let data = data {
                        completion(UIImage(data: data))
                    } else {
                        completion(nil)
                    }
                }
            })
        }*/
    }
    
}
