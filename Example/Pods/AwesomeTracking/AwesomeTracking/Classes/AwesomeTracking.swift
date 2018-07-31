//
//  AwesomeTracking.swift
//  AwesomeTracking
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/06/18.
//

import Foundation
import AwesomeCore
import AwesomeConstants

public class AwesomeTracking {
    
    fileprivate static var shared = AwesomeTracking()
    fileprivate var homeUser: HomeUserProfile?
    fileprivate var isTrackingActive: Bool = true
    
    fileprivate init() {}
    
    public static func setHomeUserProfile(with homeUser: HomeUserProfile) {
        AwesomeTracking.shared.homeUser = homeUser
    }
    
    public static func activateTracking(isActive: Bool) {
        AwesomeTracking.shared.isTrackingActive = isActive
    }
    
}

// MARK: - Super properties

extension AwesomeTracking {
    
    static fileprivate func addSuperProperties(to params: AwesomeTrackingDictionary?) -> AwesomeTrackingDictionary {
        let paramsSuper: AwesomeTrackingDictionary = [:]
        
        // assign super properties
        paramsSuper.addElement("iOS", forKey: .platform)
        paramsSuper.addElement("mva", forKey: .appId)
        paramsSuper.addElement(Locale.current.languageCode ?? "", forKey: .localisation)
        paramsSuper.addElement(Date().toString(format: "HH"), forKey: .timeOfDay)
        
        guard let homeUser = AwesomeTracking.shared.homeUser else {
            return paramsSuper
        }
        
        if let email = homeUser.email {
            paramsSuper.addElement(email, forKey: .email)
        }
        if let userUid = homeUser.uid {
            paramsSuper.addElement(userUid, forKey: .userID)
        }
        
        return paramsSuper
    }
    
}

// MARK: - Internal tracking

extension AwesomeTracking {
    
    static fileprivate func trackInternal(_ event: String, with params: AwesomeTrackingDictionary? = nil) {
        guard AwesomeTracking.shared.isTrackingActive else {
            return
        }
        
        AppsflyerHelper.track(event, with: addSuperProperties(to: params))
        BrazeHelper.track(event, with: addSuperProperties(to: params))
        FacebookHelper.track(event, with: addSuperProperties(to: params))
        MixpanelHelper.track(event, with: addSuperProperties(to: params))
    }
}

// MARK: - Tracking methods

extension AwesomeTracking {
    
    public static func track(_ event: AwesomeTrackingEvent, with params: AwesomeTrackingDictionary? = nil) {
        trackInternal(event.rawValue, with: params)
    }
    
    public static func track(_ event: AwesomeTrackingEvent.Channels, with params: AwesomeTrackingDictionary? = nil) {
        trackInternal(event.rawValue, with: params)
    }
    
    public static func track(_ event: AwesomeTrackingEvent.AwesomeMedia, with params: AwesomeTrackingDictionary? = nil) {
        trackInternal(event.rawValue, with: params)
    }
    
    public static func trackFacebookUser(_ user: HomeUserProfile) {
        BrazeHelper.trackFacebookUser(user)
    }
    
    public static func trackAppsflyerRevenue(with params: AwesomeTrackingDictionary) {
        AppsflyerHelper.trackAppsflyerRevenue(with: addSuperProperties(to: params))
    }
    
}
