//
//  String+Images.swift
//  Mindvalley
//
//  Created by Evandro Harrison Hoffmann on 2/14/18.
//  Copyright © 2018 Mindvalley. All rights reserved.
//

import UIKit

public enum ImageSize: CGFloat {
    case small = 4
    case medium = 2
    case full = 1
    case watch = 0
}


extension String {
    
    public var imageUrlForDevice: String {
        return imageUrl(forSize: UIScreen.main.bounds.size)
    }
    
    public func imageUrl(forSize size: CGSize) -> String {
        //\(self)?transform=w_\(Int(size.width)),h_\(Int(size.height)),q=\(imageDownloadQuality)
        
        // removing height and width constraints from images with constraints (last_viewed and new_trainings)
        return "\(self)?transform=w_\(Int(size.width*UIScreen.main.scale)),q=\(imageDownloadQuality)".replacingOccurrences(of: "h_405,q_auto,w_270", with: "q_auto")
    }
    
    public func imageUrl(forHeight height: CGFloat) -> String {
        //\(self)?transform=w_\(Int(size.width)),h_\(Int(size.height)),q=\(imageDownloadQuality)
        return "\(self)?transform=h_\(Int(height*UIScreen.main.scale)),q=\(imageDownloadQuality)"
    }
    
    public func sizedUrl(withSize size: ImageSize = .full) -> String? {
        guard !self.isEmpty else {
            return nil
        }
        
        //size for watch
        if size == .watch {
            return self.imageUrl(forSize: CGSize(width: 312, height: 390))
        }
        
        var size = size
        if isPad && size == .small {
            size = .medium
        }
        
        #if os(iOS)
            let width = UIDevice.current.orientation == .portrait ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height
            let height = UIDevice.current.orientation == .portrait ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width
            
            return self.imageUrl(forSize: CGSize(width: width/size.rawValue, height: height/size.rawValue))
        #else
            return url.imageUrl(forSize: CGSize(width: UIScreen.main.bounds.size.width/size.rawValue, height: UIScreen.main.bounds.size.height/size.rawValue))
        #endif
    }

    public func heightForCollectionCell(for width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: font], context: nil)
        return actualSize.height+2
    }
}
