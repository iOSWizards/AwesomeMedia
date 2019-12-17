//
//  AnswersHelper.swift
//  AwesomeTracking
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 14/08/18.
//

import Foundation
import Crashlytics

struct AnswersHelper {
    
    static func track(_ eventName: String, with params: AwesomeTrackingDictionary) {
        Answers.logCustomEvent(withName: eventName, customAttributes: params.stringLiteral())
    }
    
}
