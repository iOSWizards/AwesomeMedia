//
//  UIImageViewExtension.swift
//  Quests
//
//  Created by Antonio da Silva on 17/04/2017.
//  Copyright © 2017 Mindvalley. All rights reserved.
//

import UIKit
import Foundation

extension UIImageView {

    public func imageFromServerURL(urlString: String?, success: ((_ imageLoaded: UIImage?) -> Void)? = nil) { // success:(()->Void)? = nil

        guard let urlString = urlString else {
            return
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, _, error) -> Void in

            if error != nil {
                print(error ?? "Error while loading image for path: \(urlString)")
                return
            }

            DispatchQueue.global(qos: .userInteractive).async {
                let image = UIImage(data: data!)
                DispatchQueue.main.async(execute: { () -> Void in
                    self.image = image
                    success?(image)
                })
            }

        }).resume()
    }
}
