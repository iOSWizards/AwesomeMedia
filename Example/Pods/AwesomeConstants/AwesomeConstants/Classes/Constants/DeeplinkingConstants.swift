//
//  DeeplinkingConstants.swift
//  Mindvalley
//
//  Created by Evandro Harrison Hoffmann on 2/14/18.
//  Copyright © 2018 Mindvalley. All rights reserved.
//

import Foundation

public enum MVSchemas: String {
    case appboyScheme = "com.mindvalley.quests"
    case widget = "mvquestswidget"
}

public enum DeeplinkType: String {
    //permissions
    case allowNotifications = "permission/notifications"
    case allowHealthKit = "permission/healthKit"
    case allowSiri = "permission/siri"
    
    //course
    case academies
    case courses
    case chapters
    
    //quest
    case quests
    case days
    case intros
    case infos
    
    //products
    case products
    case pages
    
    //app
    case discover
    case membership
    case profile
    case spotlight
    case library
    case login
}
