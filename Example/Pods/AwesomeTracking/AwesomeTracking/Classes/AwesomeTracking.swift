//
//  AwesomeTracking.swift
//  AwesomeTracking
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/06/18.
//

import Foundation
import AwesomeCore
import AwesomeConstants

// MARK: - Enum for active tracking tools

public enum AwesomeTrackingTools: String {
    case braze
    case mixpanel
    case answers
    case facebook
    case appsflyer
    case mvAnalytics
}

public enum AwesomeTrackingToolsEventStream: String {
    case braze
    case mixpanel
    case appsflyer
}

public enum AwesomeTrackingAppIdentifier: String {
    case mva = "Mindvalley App"
    case quests
    case soulvana
}

public class AwesomeTracking {
    
    static var shared = AwesomeTracking()
    var user: UserProfile?
    fileprivate var isTrackingActive: Bool = true
    fileprivate var activeTools: [AwesomeTrackingTools] = [.braze, .mixpanel, .facebook, .appsflyer]
    fileprivate var appIdentifier: AwesomeTrackingAppIdentifier = .mva
    fileprivate var ftuVersion: String = "undefined"
    var activeEventstreamTools: [AwesomeTrackingToolsEventStream] = [.appsflyer, .mixpanel, .braze]
    var development: Bool = true
    
    fileprivate init() {}
    
    public static func setUserProfile(with homeUser: UserProfile) {
        AwesomeTracking.shared.user = homeUser
        MVAnalyticsHelper.runMVAnalyticsIdentify(appId: AwesomeTracking.shared.appIdentifier, homeUser: AwesomeTracking.shared.user)
    }
    
    public static func activateTracking(isActive: Bool) {
        AwesomeTracking.shared.isTrackingActive = isActive
    }
    
    public static func setActiveTrackingTools(_ tools: [AwesomeTrackingTools]) {
        AwesomeTracking.shared.activeTools = tools
    }
    
    public static func setActiveEventstreamTools(_ tools: [AwesomeTrackingToolsEventStream]) {
        AwesomeTracking.shared.activeEventstreamTools = tools
    }
    
    public static func setAppIdentifier(_ appId: AwesomeTrackingAppIdentifier) {
        AwesomeTracking.shared.appIdentifier = appId
    }
    
    public static func setFtuVersion(_ version: String) {
        AwesomeTracking.shared.ftuVersion = version
    }
    
    public static func setEnvironment(isDevelopment: Bool) {
        AwesomeTracking.shared.development = isDevelopment
    }
    
}

// MARK: - Super properties

extension AwesomeTracking {
    
    static fileprivate func addSuperProperties(to params: AwesomeTrackingDictionary?) -> AwesomeTrackingDictionary {
        var paramsSuper: AwesomeTrackingDictionary = [:]
        
        if let params = params {
            paramsSuper = params
        }
        
        // assign super properties
        paramsSuper.addElement("iOS", forKey: .platform)
        if AwesomeTracking.shared.appIdentifier == .mva {
            paramsSuper.addElement(AwesomeTracking.shared.appIdentifier.rawValue, forKey: .application)
        } else {
            paramsSuper.addElement(AwesomeTracking.shared.appIdentifier.rawValue, forKey: .appId)
        }
        paramsSuper.addElement(Locale.current.languageCode ?? "", forKey: .localisation)
        
        paramsSuper.addElement(Date().convertToUTCTime(), forKey: .timeOfDay)
        paramsSuper.addElement(UIDevice.current.localizedModel, forKey: .device)
        paramsSuper.addElement(UIDevice.current.systemName + " " + UIDevice.current.systemVersion, forKey: .os)
        
        guard let homeUser = AwesomeTracking.shared.user else {
            return paramsSuper
        }
        
        paramsSuper.addElement(homeUser.email, forKey: .email)
        
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
        
        if AwesomeTracking.shared.activeTools.contains(.appsflyer) {
            AppsflyerHelper.track(event, with: addSuperProperties(to: params))
        }
        if AwesomeTracking.shared.activeTools.contains(.braze) {
            BrazeHelper.track(event, with: addSuperProperties(to: params))
        }
        if AwesomeTracking.shared.activeTools.contains(.facebook) {
            FacebookHelper.track(event, with: addSuperProperties(to: params))
        }
        if AwesomeTracking.shared.activeTools.contains(.mixpanel) {
            MixpanelHelper.track(event, with: addSuperProperties(to: params))
        }
        if AwesomeTracking.shared.activeTools.contains(.answers) {
            AnswersHelper.track(event, with: addSuperProperties(to: params))
        }
        if AwesomeTracking.shared.activeTools.contains(.mvAnalytics) {
            MVAnalyticsHelper.track(event, with: addSuperProperties(to: params), appId: AwesomeTracking.shared.appIdentifier, user: AwesomeTracking.shared.user, ftuVersion: AwesomeTracking.shared.ftuVersion)
        }
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
    
    public static func track(_ event: AwesomeTrackingEvent.Soulvana, with params: AwesomeTrackingDictionary? = nil) {
        trackInternal(event.rawValue, with: params)
    }
    
    public static func track(_ event: String, with params: AwesomeTrackingDictionary? = nil) {
        trackInternal(event, with: params)
    }
    
    public static func trackDynamicLibrarySoulvana(_ event: String, with params: AwesomeTrackingDictionary? = nil) {
        trackInternal("view \(event) series", with: params)
    }
    
    public static func trackFacebookUser(_ user: HomeUserProfile) {
        BrazeHelper.trackFacebookUser(user)
    }
    
    public static func trackAppsflyerRevenue(with params: AwesomeTrackingDictionary) {
        AppsflyerHelper.trackAppsflyerRevenue(with: addSuperProperties(to: params))
    }
    
    public static func trackV2(_ event: String, with params: [String: String] = [:]) {
        AwesomeTrackingV2().sendEvent(event, properties: params)
    }
    
}

// MARK: - Date extension

extension Date {
    func convertToUTCTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone.init(abbreviation: "GMT")
        return formatter.string(from: self)
    }
}
