//
//  Constants.swift
//  Micro Learning App
//
//  Created by Evandro Harrison Hoffmann on 26/10/2016.
//  Copyright © 2016 Mindvalley. All rights reserved.
//

import UIKit

public let appGroupName = "group.com.mindvalley"

public let minCourseDuration: Double = 0
public let imageDownloadQuality: Int = 50
public let autoPlayVideo = true
public let autoPlayAudio = true

public var numberOfCoursesInLibrary: Int {
    if isPad {
        return 8
    }
    return 6
}
public let numberOfAcademiesInLibrary = 6

public var shouldAllowRotation: Bool = false
public var allowRotation: Bool {
    if  isPad {
        return true
    }
    
    /*if isPhone, UIDevice.current.orientation != .portrait {
     return true
     }*/
    
    return shouldAllowRotation
}
