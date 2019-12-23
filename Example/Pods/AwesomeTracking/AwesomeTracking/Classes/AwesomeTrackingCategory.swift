//
//  AwesomeTrackingCategory.swift
//  AwesomeTracking
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 19/10/18.
//

import Foundation

struct AwesomeTrackingCategory {
    
    static func getCategoryFromEvent(_ eventName: String) -> String {
        if let event = AwesomeTrackingEvent.init(rawValue: eventName) {
            switch event {
            case .userSignup, .userLogin, .userLogout, .userSignupFailed:
                return "account"
            case .applicationInstalled:
                return "app"
            default:
                return "app"
            }
        } else if let event = AwesomeTrackingEvent.Soulvana.init(rawValue: eventName) {
            switch event {
            case .appBackground, .appForeground:
                return "app"
            case .viewLiveImmersion, .authorClicked, .authorImmersionClicked, .authorScreenExit, .libraryImmersionClicked:
                return "session"
            default:
                return "app"
            }
        }
        return ""
    }
    
}
