//
//  MixpanelHelper.swift
//  AwesomeTracking
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/06/18.
//

import Foundation
import Mixpanel

struct MixpanelHelper {
    
    static func track(_ eventName: String, with params: AwesomeTrackingDictionary) {
        
        // typecast son of bitch from hell, because the mixpanel library choose to be different, they are cool ;)
        var dic: Properties = [:]

        for obj in params.stringLiteral() {
            if let value = obj.value as? String {
                dic[obj.key] = value
            } else if let value = obj.value as? Int32 {
                dic[obj.key] = Int(value)
            } else if let value = obj.value as? Bool {
                dic[obj.key] = value
            }

        }

        Mixpanel.mainInstance().track(event: eventName, properties: dic)
    }
    
}
