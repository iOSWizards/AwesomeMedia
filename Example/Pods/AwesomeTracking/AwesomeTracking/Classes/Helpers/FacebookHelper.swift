//
//  FacebookHelper.swift
//  AwesomeTracking
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/06/18.
//

import Foundation
import FBSDKCoreKit

struct FacebookHelper {
    
    static func track(_ eventName: String, with params: AwesomeTrackingDictionary) {
        AppEvents.logEvent(AppEvents.Name(rawValue: eventName), parameters: params.stringLiteral())
    }
    
}
