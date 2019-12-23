//
//  AppsflyerHelper.swift
//  AwesomeTracking
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/06/18.
//

import Foundation
import AppsFlyerLib

struct AppsflyerHelper {
    
    static func track(_ eventName: String, with params: AwesomeTrackingDictionary) {
        AppsFlyerTracker.shared().trackEvent(eventName, withValues: params.stringLiteral())
    }
    
    static func trackAppsflyerRevenue(with params: AwesomeTrackingDictionary) {
        var dict = params.stringLiteral()
        dict[AFEventParamRevenue] = params.stringLiteral()["cartValue"] as AnyObject
        dict[AFEventParamCurrency] = params.stringLiteral()["currency"] as AnyObject
        dict[AFEventParamPurchaseCurrency] = params.stringLiteral()["currency"] as AnyObject
        AppsFlyerTracker.shared().trackEvent(AFEventPurchase, withValues: dict)
    }
    
    static var appsFlyerUID: String {
        return AppsFlyerTracker.shared().getAppsFlyerUID()
    }
    
}
