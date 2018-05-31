//
//  AwesomeMedia.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import Foundation

public class AwesomeImage {
    
    public static var bundle: Bundle {
        return Bundle(for: AwesomeImage.self)
    }
    
    public static func configureCache(withMemorySize memorySize: Int = 20, diskSize: Int = 200) {
        AwesomeImageCacheManager.configureCache(withMemorySize: memorySize, diskSize: diskSize)
    }
    
}
