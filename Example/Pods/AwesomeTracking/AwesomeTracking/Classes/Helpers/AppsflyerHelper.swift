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
    
    static func trackRevenue(with params: [AwesomeTrackingParams: Any]) {
        var dict = params
//        dict[AFEventParamRevenue] = params.cartValue as AnyObject
//        dict[AFEventParamCurrency] = params.currency as AnyObject
//        dict[AFEventParamPurchaseCurrency] = params.currency as AnyObject
        AppsFlyerTracker.shared().trackEvent(AFEventPurchase, withValues: dict)
    }
    
}
